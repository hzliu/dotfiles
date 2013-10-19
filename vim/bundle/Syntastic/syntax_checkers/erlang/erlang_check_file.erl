#!/usr/bin/env escript
-export([main/1]).

main([FileName]) ->
    LibDirs = filelib:wildcard("{lib,deps}/*/ebin"),
    compile(FileName, LibDirs);

main([FileName | ["-rebar" | [Path | LibDirs]]]) ->
    {ok, L} = file:consult(Path),
    P = dict:from_list(L),
    Root = filename:dirname(Path),
    Lib1 = case dict:find(lib_dirs, P) of
             {ok, X} -> lists:map(fun(Sub) -> Root ++ "/" ++ Sub end, X);
             _ -> []
           end,

    Lib2 = case dict:find(sub_dirs, P) of
             {ok, Y} -> lists:foldl(
                          fun(Sub,Sofar) ->
                              Sofar ++ [
                                        Root ++ "/" ++ Sub,
                                        Root ++ "/" ++ Sub ++ "/include",
                                        Root ++ "/" ++ Sub ++ "/deps",
                                        Root ++ "/" ++ Sub ++ "/lib"
                                       ] end, [], Y);
             _ -> []
           end,

    LibDirs1 = LibDirs ++ Lib1 ++ Lib2,
    compile(FileName, LibDirs1);

main([FileName | LibDirs]) ->
    compile(FileName, LibDirs).

compile(FileName, LibDirs) ->
    Root = get_root(filename:dirname(FileName)),
    {ok, F} = file:open("/Users/liuhongzhang/erl_check.txt", [write]),
    io:format(F, "FileName = ~p~nRoot = ~p~n", [FileName, Root]),
    file:close(F),
    ok = code:add_pathsa(LibDirs),
    compile:file(FileName, [warn_obsolete_guard,
                            warn_unused_import,
                            warn_shadow_vars,
                            warn_export_vars,
                            strong_validation,
                            report,
                            {i, filename:join(Root, "include")},
                            {i, filename:join(Root, "deps")},
                            {i, filename:join(Root, "apps")},
                            {i, filename:join(Root, "lib")}
                        ]).

get_root(Dir) ->
    Path = filename:split(filename:absname(Dir)),
    get_root(lists:reverse(Path), Dir).

% we define the root as where Emakefile sits
has_emakefile(Files) ->
    lists:member("Emakefile", Files).

get_root([], Dir) ->
    Dir;
get_root(L = [_ | T], Dir) ->
    P = filename:join(lists:reverse(L)),
    {ok, Files}  = file:list_dir(P),
    case has_emakefile(Files) of
        true -> P;
        _ -> get_root(T, Dir)
    end.


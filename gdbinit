python
import sys, os
sys.path.insert(0, os.path.expanduser('~/.gdb/python'))
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers(None)
end

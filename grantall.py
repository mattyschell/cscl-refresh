import sys
import os
import logging
import datetime

# SET PYTHONPATH=C:\gis\geodatabase-toiler\src\py
# SET PYTHONPATH=C:\gis\cscl-refresh\src\py
import gdb
import csclrefreshmgr


if __name__ == "__main__":

    listname = sys.argv[1]
    esripriv = sys.argv[2].upper()
    esriuser = sys.argv[3].upper()

    # for example
    # src/resources/tables
    names = csclrefreshmgr.RefreshListFetcher(listname)
    
    targetsdeconn = os.environ['SDEFILE']
    targetgdb = gdb.Gdb()

    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)

    for name in names.names:

        logger.info('granting {0} on {1} to {2} at {3}'.format(esripriv
                                                              ,name
                                                              ,esriuser
                                                              ,datetime.datetime.now()))

        target = csclrefreshmgr.PostImportManager(targetgdb
                                                 ,name)

        target.grant(esripriv
                    ,esriuser)

        logger.info('completed granting {0} on {1} to {2} at {3}'.format(esripriv
                                                                        ,name
                                                                        ,esriuser
                                                                        ,datetime.datetime.now()))

    logger.info('completed {0} grants on {1} at {2}'.format(esripriv
                                                           ,listname
                                                           ,datetime.datetime.now()))
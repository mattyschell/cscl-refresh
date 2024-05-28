import os


# SET PYTHONPATH=C:\XX\geodatabase-toiler\src\py
import gdb
import fc


class RefreshListFetcher(object):

    def __init__(self,
                 whichlist):

        with open(os.path.join(os.path.dirname(__file__)
                              ,'resources'
                              ,whichlist)) as l:

            contents = [line.strip() for line in l]

        self.names = contents  

class PostImportManager(object):
    
    def __init__(self
                ,gdb
                ,targetfcname):        
         
        self.gdb = gdb
        self.name = targetfcname
        self.targetfc = fc.Fc(self.gdb
                             ,self.name)
        
    def grant(self
             ,esripriv
             ,esriuser):

        # Against all odds lets make the ESRI 
        # changeprivilegesmanagement nobs and dials even more confusing!  

        if esripriv == 'VIEW':

            self.targetfc.grantprivileges(esriuser
                                         ,'AS_IS') 

        elif esripriv == 'EDIT':

            self.targetfc.grantprivileges(esriuser
                                         ,'GRANT')

        else:

            raise ValueError('what on earth is {1}?'.format(esripriv))
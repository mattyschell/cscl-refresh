import sys
import os
import logging
import datetime
import arcpy

import csclrefreshmgr

def filterschema(gdbobjects
                ,schema='CSCL'):

    #input
    #   CSCL.ADDRESSPOINT
    #   JDOE.FOO
    #   CSCL_PUB.CongressionalDistrict
    #output
    #   CSCL.ADDRESSPOINT

    cleangdbobjects = []

    for gdbobject in gdbobjects:
        if gdbobject.startswith('{0}.'.format(schema)):
            cleangdbobjects.append(gdbobject.partition('.')[2])
    
    return cleangdbobjects


def get_relationshipclasses(workspace):

    # no desire to add relationship class management to geodatabase-toiler

    relclasses = []
    walk = arcpy.da.Walk(workspace
                        ,datatype="RelationshipClass")

    for dirpath, dirnames, filenames in walk:
        for relationshipclass in filenames:
            relclasses.append(relationshipclass)

    return filterschema(relclasses)

def get_topologies(workspace):

    # consider combining all of these to limit arcpy.da.Walk calls
    topologies = []
    walk = arcpy.da.Walk(workspace
                        ,datatype="Topology")

    for dirpath, dirnames, filenames in walk:
        for topology in filenames:
            topologies.append(topology)

    return filterschema(topologies)

def get_tables():

    return filterschema(arcpy.ListTables())

def get_feature_datasets():
    
   return filterschema(arcpy.ListDatasets())

def get_feature_classes():

    feature_classes = arcpy.ListFeatureClasses()

    for dataset in arcpy.ListDatasets():
        dataset_fcs = arcpy.ListFeatureClasses(feature_dataset = dataset)

        #add feature classes to ongoing list
        for fc in dataset_fcs:
            feature_classes.append(fc)

    return filterschema(feature_classes)

def getallobjects(workspace):

    return get_tables() \
         + get_feature_datasets() \
         + get_feature_classes() \
         + get_relationshipclasses(workspace) \
         + get_topologies(workspace)

if __name__ == "__main__":

    listname = sys.argv[1]
    arcpy.env.workspace = os.environ['SDEFILE']
    
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)

    logger.info('starting catalog verification at {0}'.format(datetime.datetime.now()))

    # what can this user see in CSCL
    existingobjects = getallobjects(arcpy.env.workspace)

    # modify this list: relationshipclasses, publicsafetywhatevers 
    # as needed.  It is correct as of implmenentation May 2024
    listnames = csclrefreshmgr.RefreshListFetcher(listname) 

    expectedobjects = []
    
    for name in listnames.names:

        objectnames = csclrefreshmgr.RefreshListFetcher(name) 
        expectedobjects = expectedobjects + objectnames.names

    # we dont check the other direction
    # extra stuff is allowed
    expectednotexisting = set(expectedobjects).difference(set(existingobjects))

    if len(expectednotexisting) == 0:
            logger.info('completed qa at {0} all good'.format(datetime.datetime.now()))
    else:
        for missing in expectednotexisting:
            logger.warning('{0} is missing!'.format(missing))





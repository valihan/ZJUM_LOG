INTERFACE zif_jum_log_const
  PUBLIC .


  CONSTANTS: BEGIN OF gc_s_log,
               BEGIN OF test,
                 test TYPE balobj_d VALUE 'ZTEST',
                 BEGIN OF subobject,
                   test1 TYPE balsubobj VALUE 'TEST1',
                   test2 TYPE balsubobj VALUE 'TEST2',
                 END OF subobject,
               END OF test,

             END OF gc_s_log.

  CONSTANTS: BEGIN OF gc_s_probclass,
               very_important TYPE balprobcl VALUE '1',
               important      TYPE balprobcl VALUE '2',
               medium         TYPE balprobcl VALUE '3',
               information    TYPE balprobcl VALUE '4',
             END OF gc_s_probclass.
ENDINTERFACE.

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

  CONSTANTS: BEGIN OF gc_s_sign,
               inclusive TYPE s_sign VALUE 'I',
               exclusive TYPE s_sign VALUE 'E',
             END OF gc_s_sign.

  CONSTANTS: BEGIN OF gc_s_option,
               eq TYPE s_option VALUE 'EQ', "equal
               ne TYPE s_option VALUE 'NE', "not equal
               bt TYPE s_option VALUE 'BT', "between
               nb TYPE s_option VALUE 'NB', "not between
               le TYPE s_option VALUE 'LE', "less equal
               ge TYPE s_option VALUE 'GE', "greater equal
               lt TYPE s_option VALUE 'LT', "less
               gt TYPE s_option VALUE 'GT', "greater
               cp TYPE s_option VALUE 'CP', "contains pattern
               np TYPE s_option VALUE 'NP', "does not contain pattern
             END OF gc_s_option.

* Severity
  CONSTANTS: BEGIN OF gc_s_mtype,
               info    TYPE bapi_mtype VALUE 'I',
               error   TYPE bapi_mtype VALUE 'E',
               warning TYPE bapi_mtype VALUE 'W',

               suc     TYPE bapi_mtype VALUE 'S',
               err     TYPE bapi_mtype VALUE 'E',
               war     TYPE bapi_mtype VALUE 'W',
               abort   TYPE bapi_mtype VALUE 'A',
               ea(2)   TYPE c          VALUE 'EA',
               eax(3)  TYPE c          VALUE 'EAX',
               wea(3)  TYPE c          VALUE 'WEA',
             END OF gc_s_mtype.
ENDINTERFACE.

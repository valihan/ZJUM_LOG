INTERFACE zif_jum_log_const
  PUBLIC .


  CONSTANTS: BEGIN OF gc_s_log,
               none TYPE balsubobj VALUE 'NONE',
               BEGIN OF test,
                 test TYPE balobj_d VALUE 'ZTEST',
                 BEGIN OF subobject,
                   test1 TYPE balsubobj VALUE 'TEST1',
                   test2 TYPE balsubobj VALUE 'TEST2',
                 END OF subobject,
               END OF test,
               BEGIN OF integration,
                 integration TYPE balobj_d VALUE 'ZINTEGRATION',
               END OF integration,
             END OF gc_s_log.

  CONSTANTS: BEGIN OF gc_s_probclass, " by if_xco_log_constants
               very_important         TYPE balprobcl VALUE '1',
               important              TYPE balprobcl VALUE '2',
               medium                 TYPE balprobcl VALUE '3',
               information            TYPE balprobcl VALUE '4',
               additional_information TYPE balprobcl VALUE '5',
               other                  TYPE balprobcl VALUE '',
             END OF gc_s_probclass.

  CONSTANTS: BEGIN OF co_level_of_detail, " by if_xco_log_constants
               one   TYPE ballevel VALUE '1',
               two   TYPE ballevel VALUE '2',
               three TYPE ballevel VALUE '3',
               four  TYPE ballevel VALUE '4',
               five  TYPE ballevel VALUE '5',
               six   TYPE ballevel VALUE '6',
               seven TYPE ballevel VALUE '7',
               eight TYPE ballevel VALUE '8',
               nine  TYPE ballevel VALUE '9',
             END OF co_level_of_detail.

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
               abort   TYPE bapi_mtype VALUE 'A',

               suc     TYPE bapi_mtype VALUE 'S',
               err     TYPE bapi_mtype VALUE 'E',
               war     TYPE bapi_mtype VALUE 'W',
               ea(2)   TYPE c          VALUE 'EA',
               eax(3)  TYPE c          VALUE 'EAX',
               wea(3)  TYPE c          VALUE 'WEA',
             END OF gc_s_mtype.
ENDINTERFACE.

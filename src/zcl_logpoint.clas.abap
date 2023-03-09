class ZCL_LOGPOINT definition
  public
  final
  create public .

public section.

  class-methods GET_NAME
    importing
      !IV_KEY type ANY optional
    returning
      value(RV_NAME) type STRING .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LOGPOINT IMPLEMENTATION.


  METHOD GET_NAME.
    GET TIME STAMP FIELD DATA(lv_timestamp).

    DATA lt_callstack TYPE abap_callstack.
    CALL FUNCTION 'SYSTEM_CALLSTACK'
      EXPORTING
        max_level = 2
      IMPORTING
        callstack = lt_callstack.
    rv_name = |{ lv_timestamp } { lt_callstack[ 2 ]-blockname } { iv_key }|.
  ENDMETHOD.
ENDCLASS.

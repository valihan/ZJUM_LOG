class ZCL_JUM_INDICATOR definition
  public
  final
  create public .

public section.

  constants GC_100 type INT4 value 100 ##NO_TEXT.

  class-methods PROGRESS_INDICATOR
    importing
      !IV_TEXT type STRING
      !IV_PERCENTAGE type INT4 optional .
protected section.
private section.
ENDCLASS.



CLASS ZCL_JUM_INDICATOR IMPLEMENTATION.


  METHOD progress_indicator.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = iv_percentage
        text       = iv_text.
  ENDMETHOD.
ENDCLASS.

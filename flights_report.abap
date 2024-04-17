*&---------------------------------------------------------------------*
*& Report Z_FLIGHTS_REGISTRATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_flights_registration.

TYPES: BEGIN OF report_structure,
         cia_area   TYPE s_carr_id,
         flight_num TYPE s_conn_id,
         date       TYPE s_date,
         price      TYPE s_price.
TYPES: END OF report_structure.

CONSTANTS: header_price_position   TYPE i VALUE 36,
           body_flightnum_position TYPE i VALUE 10,
           body_data_position      TYPE i VALUE 24,
           body_price_position     TYPE i VALUE 36,
           column                  TYPE c LENGTH 1 VALUE '|'.

DATA: flight_table  TYPE STANDARD TABLE OF report_structure,
      report_fields LIKE LINE OF flight_table.

START-OF-SELECTION.

  SELECT-OPTIONS: s_cia FOR report_fields-cia_area NO INTERVALS NO-EXTENSION,
                  s_fl_n FOR report_fields-flight_num,
                  s_date FOR report_fields-date,
                  s_price FOR report_fields-price.

  ULINE AT (56).
  NEW-LINE.
  FORMAT COLOR 6.
  WRITE: column, TEXT-001, column,
         TEXT-002,column,
         TEXT-003,column,
         TEXT-004,column.

  FORMAT COLOR OFF.

  NEW-LINE.
  ULINE AT (56).


  SELECT
    carrid connid fldate price
    FROM sflight
    INTO TABLE flight_table
    WHERE carrid IN s_cia
    AND connid IN s_fl_n
    AND fldate IN s_date
    AND price IN s_price.

  IF sy-subrc = 0.
    LOOP AT flight_table INTO report_fields.
      PERFORM data_body USING report_fields-cia_area report_fields-flight_num report_fields-date report_fields-price.
    ENDLOOP.

    PERFORM msg_success.

  ELSE .

    MESSAGE 'Records not found' TYPE 'E'.

  ENDIF.


  NEW-LINE.
  ULINE AT (56).
  NEW-LINE.
  WRITE 'Report created on:'.
  WRITE sy-datum.


FORM data_body USING cia_area flight_num date price.

  NEW-LINE.
  WRITE: column, (8) cia_area LEFT-JUSTIFIED, column,
         (13) flight_num LEFT-JUSTIFIED, column,
         (12) date DD/MM/YYYY, column,
         (10) price LEFT-JUSTIFIED, column.
ENDFORM.

FORM msg_success.
  DATA: records_num TYPE string,
        msg         TYPE string.

  records_num = sy-dbcnt.
  CONCATENATE 'Success!' records_num 'records found.' INTO msg SEPARATED BY space.


  MESSAGE msg TYPE 'S'.
ENDFORM.
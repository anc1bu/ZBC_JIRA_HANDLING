CLASS zbc_cl_jira_cts_desc_change DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS: change_as4text CHANGING  text TYPE as4text.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: yes TYPE c VALUE '1',
               no  TYPE c VALUE '2'.
ENDCLASS.

CLASS zbc_cl_jira_cts_desc_change IMPLEMENTATION.

  METHOD change_as4text.

    DATA: answer TYPE c.

    text = to_upper( text ).

    CHECK: text(3) EQ 'YUR'.

    DATA(jira) = NEW zbc_cl_jira_json_issues( ).

    jira->get_issues( VALUE #( ( issue_id = text ) ) ).

    CALL FUNCTION 'POPUP_WITH_2_BUTTONS_TO_CHOOSE'
      EXPORTING
        defaultoption = '1'
        diagnosetext1 = 'Request will be created for the following item.Ok?'
*       diagnosetext2 = space
*       diagnosetext3 = space
        textline1     = |Jira no : { jira->issues[ key = text ]-key }|
        textline2     = |Summary : { jira->issues[ key = text ]-fields-summary }|
        textline3     = |Status : { jira->issues[ key = text ]-fields-status-name }|
        text_option1  = 'Yes'
        text_option2  = 'No'
        titel         = 'Issue Info Check'
      IMPORTING
        answer        = answer.
    IF answer EQ yes.
      text = |{ jira->issues[ key = text ]-key } - { jira->issues[ key = text ]-fields-summary }|.
    ELSE.
      LEAVE SCREEN.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

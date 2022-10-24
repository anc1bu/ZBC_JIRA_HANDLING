CLASS zbc_cl_jira_json_issues DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA: jira_client TYPE REF TO zbc_cl_rest_client,
                issues      TYPE TABLE OF zbcs_jira_json_issue.

    CLASS-METHODS: class_constructor.

    METHODS: get_issues IMPORTING issue_ids TYPE zbctt_jira_issue_id.

  PROTECTED SECTION.

  PRIVATE SECTION.

    CLASS-DATA: cust TYPE zbcs_http_client_customizing.

    CONSTANTS: http_client_name TYPE zbcde_http_client VALUE 'JIRA'.

ENDCLASS.



CLASS zbc_cl_jira_json_issues IMPLEMENTATION.

  METHOD class_constructor.

    SELECT SINGLE FROM zbct_http_client
                FIELDS *
                WHERE  http_client = @http_client_name
                INTO   CORRESPONDING FIELDS OF @cust.
    CHECK: sy-subrc EQ 0.

    jira_client = NEW #( cust ).

  ENDMETHOD.


  METHOD get_issues.

    DATA: issue TYPE zbcs_jira_json_issue.

    LOOP AT issue_ids ASSIGNING FIELD-SYMBOL(<issue_id>).
      CHECK NOT line_exists( issues[ key = <issue_id>-issue_id ] ).

      jira_client->get( EXPORTING uri  = |/rest/api/latest/issue/{ <issue_id>-issue_id } |
                        CHANGING  data = issue ).

      INSERT issue INTO TABLE issues.

    ENDLOOP.

    jira_client->close( ).

  ENDMETHOD.

ENDCLASS.

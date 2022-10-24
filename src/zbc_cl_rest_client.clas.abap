CLASS zbc_cl_rest_client DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA: http_client TYPE REF TO if_http_client,
                rest_client TYPE REF TO cl_rest_http_client.

    METHODS:
      constructor IMPORTING cust TYPE zbcs_http_client_customizing,
      get IMPORTING uri  TYPE string
          CHANGING  data TYPE any,
      close.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zbc_cl_rest_client IMPLEMENTATION.

  METHOD constructor.

    cl_http_client=>create( EXPORTING  host               = CONV #( cust-host )
                                       service            = CONV #( cust-service )
                                       scheme             = CONV #( cust-scheme )
                                       ssl_id             = cust-ssl_id
                            IMPORTING  client             = me->http_client
                            EXCEPTIONS argument_not_found = 1
                                       plugin_not_active  = 2
                                       internal_error     = 3
                                       OTHERS             = 4 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
* Set HTTP client
    http_client->request->set_version( if_http_request=>co_protocol_version_1_0 ).
    http_client->propertytype_logon_popup = http_client->co_disabled.
    me->rest_client = NEW #( http_client ).

* Set request header if any
    rest_client->if_rest_client~set_request_header( EXPORTING iv_name  = 'Authorization'
                                                              iv_value = |Bearer { cust-bearer_token }| ).

  ENDMETHOD.

  METHOD get.

    CHECK: http_client IS BOUND,
           rest_client IS BOUND.


    cl_http_utility=>set_request_uri( EXPORTING request = me->http_client->request
                                                uri     = uri ).

* HTTP GET
    rest_client->if_rest_client~get( ).
* HTTP response
    DATA(response) = rest_client->if_rest_client~get_response_entity( ).
* HTTP return status
    DATA(status_code) = response->get_header_field( '~status_code' ).
    IF response->get_header_field( '~status_code' ) EQ '200'.
* HTTP JSON return string
      DATA(json_response) = response->get_string_data( ).

      /ui2/cl_json=>deserialize( EXPORTING json = json_response
                                 CHANGING  data = data ).
    ENDIF.


  ENDMETHOD.

  METHOD close.
    http_client->close( ).
  ENDMETHOD.

ENDCLASS.

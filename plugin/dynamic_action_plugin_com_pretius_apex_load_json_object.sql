prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>8205260902819239028
,p_default_application_id=>185220
,p_default_id_offset=>0
,p_default_owner=>'LUFCMATTYLAD'
);
end;
/
 
prompt APPLICATION 185220 - 🔥
--
-- Application Export:
--   Application:     185220
--   Name:            🔥
--   Date and Time:   10:33 Wednesday January 28, 2026
--   Exported By:     LUFC
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 130707185213027823646
--   Manifest End
--   Version:         24.2.11
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_pretius_apex_load_json_object
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(130707185213027823646)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.PRETIUS.APEX.LOAD_JSON_OBJECT'
,p_display_name=>'Pretius Load JSON Object'
,p_category=>'EXECUTE'
,p_javascript_file_urls=>'#PLUGIN_FILES#pretiusLoadJSONObject#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render',
'    ( p_dynamic_action in apex_plugin.t_dynamic_action',
'    , p_plugin         in apex_plugin.t_plugin',
'    )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result                    apex_plugin.t_dynamic_action_render_result;',
'    l_javascript_variable       varchar2(4000) := p_dynamic_action.attribute_06;',
'    --surrounded by quotes as it will be used a parameter',
'    l_js_literal                varchar2(4000) := apex_escape.js_literal(l_javascript_variable , ''"'' );',
'    --not surrounded by quotes, as it will be on the left side of an assignment',
'    l_js_literal_with_window    varchar2(4000) := apex_escape.js_literal(''window.'' || l_javascript_variable, null);',
'begin',
'    -- Debug',
'    apex_plugin_util.debug_dynamic_action',
'        ( p_plugin         => p_plugin',
'        , p_dynamic_action => p_dynamic_action',
'        );',
'',
'    ',
'    -- Generate Client-Side JavaScript',
'    l_result.javascript_function := apex_string.format(q''[',
'       function() {',
'           pretiusLoadJSONObject.render(this)',
'       }',
'    ]'', ',
'        apex_escape.js_literal(l_js_literal_with_window)',
'    );',
'',
'    -- Settings',
'    l_result.attribute_01 := p_dynamic_action.attribute_01;',
'    l_result.attribute_02 := p_dynamic_action.attribute_02;',
'    l_result.attribute_03 := p_dynamic_action.attribute_03;',
'    l_result.attribute_04 := p_dynamic_action.attribute_04;',
'    l_result.attribute_05 := p_dynamic_action.attribute_05;',
'    l_result.attribute_06 := l_js_literal_with_window;',
'    l_result.attribute_07 := p_dynamic_action.attribute_07;',
'    l_result.attribute_08 := p_dynamic_action.attribute_08;',
'    l_result.attribute_09 := p_dynamic_action.attribute_09;',
'    l_result.attribute_10 := p_dynamic_action.attribute_10;',
'',
'    -- Result',
'    l_result.ajax_identifier := apex_plugin.get_ajax_identifier;  ',
'',
'    return l_result;',
'end render;',
'',
'function ajax',
'    ( p_dynamic_action in apex_plugin.t_dynamic_action',
'    , p_plugin         in apex_plugin.t_plugin',
'    )',
'return apex_plugin.t_dynamic_action_ajax_result',
'as',
'    l_result apex_plugin.t_dynamic_action_ajax_result;',
'',
'    l_source                  p_dynamic_action.attribute_01%TYPE DEFAULT p_dynamic_action.attribute_01;',
'    l_sql                     p_dynamic_action.attribute_02%TYPE DEFAULT p_dynamic_action.attribute_02;',
'    l_json_sql                p_dynamic_action.attribute_03%TYPE DEFAULT p_dynamic_action.attribute_03;',
'    l_plsql_json              p_dynamic_action.attribute_04%TYPE DEFAULT p_dynamic_action.attribute_04;',
'    l_static_json             p_dynamic_action.attribute_05%TYPE DEFAULT p_dynamic_action.attribute_05;',
'    ',
'    l_clob                    clob;',
'    l_json_clob               clob;',
'begin',
'    -- Debug',
'    apex_plugin_util.debug_dynamic_action',
'        ( p_plugin         => p_plugin',
'        , p_dynamic_action => p_dynamic_action',
'        );',
'',
'    -- Generate the JSON Data based on source type',
'    case l_source',
'        when ''sql'' then',
'            declare',
'                l_context apex_exec.t_context;',
'            begin',
'                l_context := apex_exec.open_query_context(',
'                    p_location          => apex_exec.c_location_local_db,',
'                    p_sql_query         => l_sql,',
'                    p_auto_bind_items   => true',
'                );',
'                ',
'                apex_json.initialize_clob_output(p_indent => 0);',
'                apex_json.open_array;',
'                apex_json.write_context(l_context);',
'                apex_json.close_array;',
'                ',
'                apex_exec.close(l_context);',
'                ',
'                l_json_clob := apex_json.get_clob_output;',
'                apex_json.free_output;',
'                ',
'                apex_util.prn( p_clob => l_json_clob, p_escape => false );',
'            exception',
'                when others then',
'                    apex_exec.close(l_context);',
'                    apex_json.free_output;',
'                    raise;',
'            end;',
'',
'        when ''jsonsql'' then',
'            declare',
'                l_column_value_list apex_plugin_util.t_column_value_list;',
'            begin',
'                l_column_value_list := apex_plugin_util.get_data(',
'                    p_sql_statement  => l_json_sql,',
'                    p_min_columns    => 1,',
'                    p_max_columns    => 1,',
'                    p_component_name => p_dynamic_action.name',
'                );',
'                ',
'                if l_column_value_list.exists(1) and l_column_value_list(1).count > 0 then',
'                    l_clob := l_column_value_list(1)(1);',
'                    apex_util.prn( p_clob => l_clob, p_escape => false );',
'                else',
'                     apex_util.prn(''{}'');',
'                end if;',
'            end;',
'            ',
'        when ''plsql'' then',
'            apex_json.initialize_clob_output(p_indent => 0);',
'            apex_plugin_util.execute_plsql_code( p_plsql_code => l_plsql_json );',
'            ',
'            l_json_clob := apex_json.get_clob_output;',
'            apex_json.free_output;',
'            ',
'            apex_util.prn( p_clob => l_json_clob, p_escape => false );',
'            ',
'        when ''static'' then',
'            apex_util.prn( p_clob => l_static_json, p_escape => false );',
'    end case;',
'',
'    return l_result;',
'end ajax;',
''))
,p_api_version=>1
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_version_scn=>15708836120492
,p_subscribe_plugin_settings=>true
,p_help_text=>'<p>Loads a JSON Object into the page.</p>'
,p_version_identifier=>'24.2.1'
,p_about_url=>'https://github.com/pretius/Pretius-Load-JSON-Object'
,p_files_version=>67
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(131195213334556886884)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_title=>unistr('\2692\FE0F Settings')
,p_display_sequence=>10
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(130707225915759828236)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Source'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'sql'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(130707451337066464961)
,p_plugin_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_display_sequence=>10
,p_display_value=>'SQL Query'
,p_return_value=>'sql'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(130707469072342465719)
,p_plugin_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_display_sequence=>20
,p_display_value=>'SQL Query Returning JSON Object'
,p_return_value=>'jsonsql'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(130707695864643466709)
,p_plugin_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_display_sequence=>30
,p_display_value=>'PL/SQL Procedure'
,p_return_value=>'plsql'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(130707709754146467619)
,p_plugin_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_display_sequence=>40
,p_display_value=>'Static'
,p_return_value=>'static'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(130707862758251480059)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>select * from emp</pre> ',
'',
'<p>will be translated into the following JSON Object:</p>',
'',
'<pre>',
'{"row":[',
'{"EMPNO":7369,"ENAME":"SMITH","JOB":"CLERK","MGR":7902,"HIREDATE":"17-DEC-80","SAL":800,"COMM":"","DEPTNO":20},',
'{"EMPNO":7499,"ENAME":"ALLEN","JOB":"SALESMAN","MGR":7698,"HIREDATE":"20-FEB-81","SAL":1600,"COMM":300,"DEPTNO":30},',
'{"EMPNO":7521,"ENAME":"WARD","JOB":"SALESMAN","MGR":7698,"HIREDATE":"22-FEB-81","SAL":1250,"COMM":500,"DEPTNO":30},',
'... ',
']}</pre>',
'',
'<p>To then filter for a specific record, you can use something like:</p>',
'',
'<pre>var record = objectName.row.filter(function(row){return row.ENAME == ''BLAKE''})[0];</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This is the easiest way to create a JSON Object based on a table.</p>',
'<p>The resulting rows can be accessed via <code>objectName.row[0]<code>, <code>.row[1]</code>, etc.</p>',
'<h3><b>Notes</b></h3>',
'<ul>',
'<li>This is not the most proper way to create a JSON object. Consider using SQL Query Returning JSON Object or PL/SQL Procedure for more control.</li>',
'<li>Values over 4000 characters in length will get cut off at 4000. Use the aforementioned options to circumvent this.</li>',
'</ul>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(130707894272541483072)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>1
,p_sql_max_column_count=>1
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'jsonsql'
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'    <h3>Example 1</h3>',
'',
'    <p>The function <code>json_object</code> converts the data to an object. You can use it to have more flexibility in terms of renaming columns, generating nested objects, etc.</p>',
'    <p>Using it on its own, the query would return a row for each object. We have to therefore wrap it in a <code>json_arrayagg</code> function to convert it into a one row array.</p>',
'',
'    <pre>',
'select json_arrayagg(',
'           json_object( ''id''       value empno',
'                      , ''name''     value ename',
'                      , ''pay''      value sal',
'                      )',
'       ) as employees',
'  from emp</pre>',
'',
'    <p>will result in:</p>',
'',
'    <pre>',
'[',
' {"id":7369, "name":"SMITH",  "pay":800 },',
' {"id":7499, "name":"ALLEN",  "pay":1600},',
' {"id":7521, "name":"WARD",   "pay":1250},',
' {"id":7566, "name":"JONES",  "pay":2975},',
' {"id":7654, "name":"MARTIN", "pay":1250},',
' {"id":7698, "name":"BLAKE",  "pay":2850},',
' {"id":7782, "name":"CLARK",  "pay":2450},',
' {"id":7788, "name":"SCOTT",  "pay":3000},',
' {"id":7839, "name":"KING",   "pay":5000},',
' {"id":7844, "name":"TURNER", "pay":1500},',
' {"id":7876, "name":"ADAMS",  "pay":1100},',
' {"id":7900, "name":"JAMES",  "pay":950 },',
' {"id":7902, "name":"FORD",   "pay":3000},',
' {"id":7934, "name":"MILLER", "pay":1300}',
']</pre>',
'',
'    <h3>Example 2</h3>',
'',
'    <p>Here we generate a simple key value pair object. Instead of combining the rows into an array, we can use <code>json_objectagg</code> to merge the rows into 1 object, as the keys in this case are always unique.</p>',
'',
'    <pre>',
'select json_objectagg(dname value deptno) ',
'  from dept</pre>',
'',
'    <p>will result in:</p>',
'',
'    <pre>{"ACCOUNTING":10,"RESEARCH":20,"SALES":30,"OPERATIONS":40}</pre>',
'',
'    <h3>Example 3</h3>',
'',
'    <p>A more complex example which will list all departments and the employees assigned to them.</p>',
'',
'    <pre>',
'select json_arrayagg(',
'        json_object',
'            ( ''department_name'' value d.dname',
'            , ''department_no''   value d.deptno',
'            , ''employees''       value (',
'                select json_arrayagg (',
'                    json_object',
'                        ( ''employee_number'' value e.empno',
'                        , ''employee_name''   value e.ename',
'                        )',
'                )',
'                 from emp e',
'                where e.deptno = d.deptno',
'              )',
'           )',
'      ) as departments',
' from dept d</pre>',
'',
'    <p>will result in:</p>',
'',
'    <pre>',
'[  ',
'{"department_name":"ACCOUNTING","department_no":10,"employees":[  ',
'      {"employee_number":7782, "employee_name":"CLARK"},',
'      {"employee_number":7839, "employee_name":"KING"},',
'      {"employee_number":7934, "employee_name":"MILLER"}',
'    ]},',
'{"department_name":"RESEARCH", "department_no":20,"employees":[  ',
'      {"employee_number":7369, "employee_name":"SMITH"},',
'      {"employee_number":7566, "employee_name":"JONES"},',
'      {"employee_number":7788, "employee_name":"SCOTT"},',
'      {"employee_number":7876, "employee_name":"ADAMS"},',
'      {"employee_number":7902, "employee_name":"FORD"}',
'    ]},',
'{"department_name":"SALES", "department_no":30, "employees":[  ',
'      {"employee_number":7499, "employee_name":"ALLEN"},',
'      {"employee_number":7521, "employee_name":"WARD"},',
'      {"employee_number":7654, "employee_name":"MARTIN"},',
'      {"employee_number":7698, "employee_name":"BLAKE"},',
'      {"employee_number":7844, "employee_name":"TURNER"},',
'      {"employee_number":7900, "employee_name":"JAMES"}',
'    ]},',
'{"department_name":"OPERATIONS", "department_no":40, "employees":null}',
']</pre>',
'',
'</p>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The SQL Query must return a 1 column/ 1 row result set, populated with a JSON Object.</p>',
'<p>The JSON Object can either be fetched from a JSON column in a table, or dynamically created using <code>json_object</code>, <code>json_array</code>, etc function calls.</p>',
'<p>This method lets you have much more control over the format of the object, and can handle CLOBs.</p>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(130708110496915857616)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'PL/SQL Code'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'plsql'
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Example courtesy of oracle-base.com</p>',
'<pre>',
'declare',
'  l_deptno   dept.deptno%TYPE := 10;',
'  l_dept_row dept%ROWTYPE;',
'begin',
'  ',
'  apex_json.open_object; -- {',
'',
'  select d.*',
'    into l_dept_row',
'    from dept d',
'   where d.deptno = l_deptno;',
'',
'  apex_json.open_object(''department''); -- department {',
'  apex_json.write(''department_number'', l_dept_row.deptno);',
'  apex_json.write(''department_name'', l_dept_row.dname);',
' ',
'  apex_json.open_array(''employees''); -- employees: [',
'  ',
'  for cur_rec in (select * from emp e where e.deptno = l_deptno)',
'  loop',
'    apex_json.open_object; -- {',
'    apex_json.write(''employee_number'', cur_rec.empno);',
'    apex_json.write(''employee_name'', cur_rec.ename);',
'    apex_json.close_object; -- } employee',
'  end loop;',
'',
'  apex_json.close_array; -- ] employees',
'  apex_json.close_object; -- } department',
'',
'  apex_json.open_object(''metadata''); -- metadata {',
'  apex_json.write(''published_date'', to_char(sysdate, ''DD-MON-YYYY''));',
'  apex_json.write(''publisher'', ''oracle-base.com'');',
'  apex_json.close_object; -- } metadata ',
'  ',
'  apex_json.close_object; -- }',
'',
'end;</pre>',
'',
'<p>will output the following object:</p>',
'',
'<pre>',
'{',
'"department":{"department_number":10,"department_name":"ACCOUNTING",',
'    "employees":[',
'        {"employee_number":7782,"employee_name":"CLARK"},',
'        {"employee_number":7839,"employee_name":"KING"},',
'        {"employee_number":7934,"employee_name":"MILLER"}',
'    ]},',
'"metadata":{"published_date":"24-APR-2019","publisher":"oracle-base.com"}',
'}',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Here you can build the JSON Object dynamically using for example the <code>APEX_JSON</code> package.',
'<p>Calls to <code>APEX_JSON</code> procedures internally output to the http buffer, so there is nothing to manually print or return.</p>',
'<p>You can use this method if the JSON Object is impossible or too complicated to create in pure SQL.</p>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(130707951530463489590)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'JSON Object'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'{"empNo": 7839, "ename": "Blake", "departments": ["Accounting", "Research", "Sales"]}',
'</pre>'))
,p_help_text=>'<p>Provide the JSON Object as plain text, but still well formatted.</p>'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(130707978687264491593)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Load Into'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'pageData'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_examples=>'<p>If you specify for example <code>myApp.data</code>, the object will be accesible via <code>myApp.data</code> and <code>window.myApp.data</code> in any JavaScript context, e.g Execute JavaScript Code dynamic actions.</p>'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The JavaScript variable path the JSON object will be loaded into.</p>',
'<p>If the variable is nested, it will be created if it does not exist.</p>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131195642332674538089)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Remove Object before Load'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_help_text=>'If enabled; the object is removed first before loading. Disable if you want to build up the object over several calls to this plugin'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131197949105878596218)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>55
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(130707225915759828236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'static'
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enter the uppercase page items submitted to the server, and therefore, available for use within your PL/SQL Code.',
'',
'You can type in the item name or pick from the list of available items. If you pick from the list and there is already text entered then a comma is placed at the end of the existing text, followed by the item name returned from the list.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131226673951385675402)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Execute JavaScript Code (on success)'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This code has access to the following dynamic action related attributes:',
'',
'this.triggeringElement',
'A reference to the DOM object of the element that triggered the dynamic action.',
'this.affectedElements',
'A jQuery object containing all the affected elements.',
'this.action',
'The action object containing details such as the action name and additional attribute values.',
'this.browserEvent',
'The event object of event that triggered the event. Note: On load this equals ''load''.',
'this.data',
'Optional additional data that can be passed from the event handler.'))
,p_help_text=>'Enter any custom JavaScript that is specific to the page or dynamic action to run only on successful fetch from DB'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131280251744616992581)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>85
,p_prompt=>'Show Spinner'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(131195213334556886884)
,p_help_text=>'Shows a simple spinner on the triggeringElement'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '76617220707265746975734C6F61644A534F4E4F626A656374203D202866756E6374696F6E202829207B0A0A2020202066756E6374696F6E2072656E64657228705468697329207B0A2020202020202020766172206461203D2070546869733B0A202020';
wwv_flow_imp.g_varchar2_table(2) := '2020202020766172206C4A734C69746572616C5769746857696E646F77203D2064612E616374696F6E2E61747472696275746530363B0A2020202020202020766172206C52656D6F76654F626A656374203D2064612E616374696F6E2E61747472696275';
wwv_flow_imp.g_varchar2_table(3) := '746530373B0A2020202020202020766172206C706167654974656D73546F5375626D6974203D2064612E616374696F6E2E61747472696275746530383B0A2020202020202020766172206C4A617661536372697074436F6465203D2064612E616374696F';
wwv_flow_imp.g_varchar2_table(4) := '6E2E61747472696275746530393B0A2020202020202020766172206C73686F775370696E6E6572203D2064612E616374696F6E2E61747472696275746531303B0A0A2020202020202020766172206C706167654974656D73546F5375626D697441727261';
wwv_flow_imp.g_varchar2_table(5) := '79203D20617065782E7574696C2E746F4172726179286C706167654974656D73546F5375626D69742C20222C22293B0A0A20202020202020206C706167654974656D73546F5375626D6974203D206C706167654974656D73546F5375626D697441727261';
wwv_flow_imp.g_varchar2_table(6) := '790A2020202020202020202020202E6D6170286974656D203D3E20222322202B206974656D2E7472696D28292E746F5570706572436173652829290A2020202020202020202020202E6A6F696E28222C22293B0A0A202020202020202076617220737069';
wwv_flow_imp.g_varchar2_table(7) := '6E6E65723B0A0A2020202020202020696620286C73686F775370696E6E6572203D3D2027592729207370696E6E6572203D20617065782E7574696C2E73686F775370696E6E65722864612E74726967676572696E67456C656D656E74293B200A0A202020';
wwv_flow_imp.g_varchar2_table(8) := '2020202020617065782E7365727665722E706C7567696E280A20202020202020202020202064612E616374696F6E2E616A61784964656E7469666965722C0A2020202020202020202020207B0A2020202020202020202020202020202070616765497465';
wwv_flow_imp.g_varchar2_table(9) := '6D733A206C706167654974656D73546F5375626D69740A2020202020202020202020207D2C0A2020202020202020202020207B0A2020202020202020202020202020202064617461547970653A20226A736F6E222C202F2F20457870656374696E67204A';
wwv_flow_imp.g_varchar2_table(10) := '534F4E0A20202020202020202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0A0A20202020202020202020202020202020202020202F2F2068747470733A2F2F737461636B6F766572666C6F772E636F6D2F612F';
wwv_flow_imp.g_varchar2_table(11) := '31383038323137350A202020202020202020202020202020202020202066756E6374696F6E206576696C28666E2C20636F6E7465787429207B0A2020202020202020202020202020202020202020202020207661722066756E63203D206E65772046756E';
wwv_flow_imp.g_varchar2_table(12) := '6374696F6E282772657475726E2027202B20666E2928293B0A20202020202020202020202020202020202020202020202072657475726E2066756E632E63616C6C28636F6E74657874293B0A20202020202020202020202020202020202020207D0A0A20';
wwv_flow_imp.g_varchar2_table(13) := '20202020202020202020202020202020202020766172206372656174654E65737465644F626A656374203D2066756E6374696F6E2028652C207429207B20666F7220287661722072203D202874203D20742E73706C697428222E2229292E6C656E677468';
wwv_flow_imp.g_varchar2_table(14) := '202D20312C2061203D20303B2061203C20723B202B2B6129207B20766172206E203D20745B615D3B206E20696E2065207C7C2028655B6E5D203D207B7D292C2065203D20655B6E5D207D207D3B0A0A202020202020202020202020202020202020202063';
wwv_flow_imp.g_varchar2_table(15) := '72656174654E65737465644F626A6563742877696E646F772C206C4A734C69746572616C5769746857696E646F77293B0A0A20202020202020202020202020202020202020202F2F20312E2052656D6F7665204F626A6563740A20202020202020202020';
wwv_flow_imp.g_varchar2_table(16) := '20202020202020202020696620286C52656D6F76654F626A656374203D3D3D2027592729207B0A2020202020202020202020202020202020202020202020202F2F20506172736520616E642064656C65746520746865206578697374696E67206F626A65';
wwv_flow_imp.g_varchar2_table(17) := '63740A202020202020202020202020202020202020202020202020766172207061727473203D206C4A734C69746572616C5769746857696E646F772E73706C697428272E27293B0A20202020202020202020202020202020202020202020202076617220';
wwv_flow_imp.g_varchar2_table(18) := '70726F704E616D65203D2070617274732E706F7028293B0A20202020202020202020202020202020202020202020202076617220706172656E74203D2070617274732E7265647563652866756E6374696F6E20286163632C207061727429207B0A202020';
wwv_flow_imp.g_varchar2_table(19) := '2020202020202020202020202020202020202020202020202072657475726E206163635B706172745D3B0A2020202020202020202020202020202020202020202020207D2C2077696E646F77293B0A0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(20) := '2020202069662028706172656E742026262070726F704E616D6520696E20706172656E7429207B0A2020202020202020202020202020202020202020202020202020202064656C65746520706172656E745B70726F704E616D655D3B0A20202020202020';
wwv_flow_imp.g_varchar2_table(21) := '20202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A0A20202020202020202020202020202020202020202F2F20322E2050617273652074686520737472696E6720746F20676574207468652070617265';
wwv_flow_imp.g_varchar2_table(22) := '6E74206F626A65637420616E64207468652066696E616C2070726F7065727479206E616D650A2020202020202020202020202020202020202020766172207061727473203D206C4A734C69746572616C5769746857696E646F772E73706C697428272E27';
wwv_flow_imp.g_varchar2_table(23) := '293B0A20202020202020202020202020202020202020207661722070726F704E616D65203D2070617274732E706F7028293B202F2F2045787472616374732066696E616C207461670A20202020202020202020202020202020202020202F2F2074726176';
wwv_flow_imp.g_varchar2_table(24) := '657273652066726F6D20746F70206C6576656C20646F776E20746F2074686520706172656E74206F66207468652066696E616C2070726F70657274790A202020202020202020202020202020202020202076617220706172656E74203D2070617274732E';
wwv_flow_imp.g_varchar2_table(25) := '7265647563652866756E6374696F6E20286163632C207061727429207B0A20202020202020202020202020202020202020202020202072657475726E206163635B706172745D3B0A20202020202020202020202020202020202020207D2C2077696E646F';
wwv_flow_imp.g_varchar2_table(26) := '77293B0A0A20202020202020202020202020202020202020202F2F20332E2044796E616D6963206571756976616C656E74206F663A2077696E646F772E61707064617461203D2077696E646F772E61707064617461207C7C207B7D3B0A20202020202020';
wwv_flow_imp.g_varchar2_table(27) := '20202020202020202020202020706172656E745B70726F704E616D655D203D20706172656E745B70726F704E616D655D207C7C207B7D3B0A0A20202020202020202020202020202020202020202F2F20342E2044796E616D6963206571756976616C656E';
wwv_flow_imp.g_varchar2_table(28) := '74206F663A204F626A6563742E61737369676E2877696E646F772E617070646174612C207B2261223A20327D293B0A20202020202020202020202020202020202020204F626A6563742E61737369676E28706172656E745B70726F704E616D655D2C2070';
wwv_flow_imp.g_varchar2_table(29) := '44617461293B0A0A20202020202020202020202020202020202020202F2F2052656D6F7665205370696E6E65720A2020202020202020202020202020202020202020696620287370696E6E657229207370696E6E65722E72656D6F766528293B0A0A2020';
wwv_flow_imp.g_varchar2_table(30) := '2020202020202020202020202020202020202F2F20352E2045786563757465204A5320436F64650A2020202020202020202020202020202020202020696620286C4A617661536372697074436F646529207B0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(31) := '20202020202020747279207B0A202020202020202020202020202020202020202020202020202020206576696C28272866756E6374696F6E202829207B5C6E27202B206C4A617661536372697074436F6465202B20275C6E7D29272C206461293B0A2020';
wwv_flow_imp.g_varchar2_table(32) := '202020202020202020202020202020202020202020207D20636174636820286529207B0A20202020202020202020202020202020202020202020202020202020636F6E736F6C652E6572726F7228224576696C20657865637574696F6E206572726F723A';
wwv_flow_imp.g_varchar2_table(33) := '222C2065293B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A0A20202020202020202020202020202020202020202F2F20526573756D652044796E616D696320416374696F6E';
wwv_flow_imp.g_varchar2_table(34) := '730A20202020202020202020202020202020202020206966202864612E616374696F6E2E77616974466F72526573756C7429207B0A202020202020202020202020202020202020202020202020617065782E64612E726573756D652864612E726573756D';
wwv_flow_imp.g_varchar2_table(35) := '6543616C6C6261636B2C2066616C7365293B0A20202020202020202020202020202020202020207D0A0A202020202020202020202020202020207D2C0A202020202020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C';
wwv_flow_imp.g_varchar2_table(36) := '20746578745374617475732C206572726F725468726F776E29207B0A2020202020202020202020202020202020202020696620287370696E6E657229207370696E6E65722E72656D6F766528293B0A202020202020202020202020202020202020202063';
wwv_flow_imp.g_varchar2_table(37) := '6F6E736F6C652E6572726F7228224A534F4E204C6F6164204572726F7220666F72207661726961626C653A2022202B206C4A734C69746572616C5769746857696E646F772C20746578745374617475732C206572726F725468726F776E293B0A20202020';
wwv_flow_imp.g_varchar2_table(38) := '202020202020202020202020202020206966202864612E616374696F6E2E77616974466F72526573756C7429207B0A2020202020202020202020202020202020202020202020202F2F2070617373207472756520746F2053746F7020457865637574696F';
wwv_flow_imp.g_varchar2_table(39) := '6E206F6E204572726F720A202020202020202020202020202020202020202020202020617065782E64612E726573756D652864612E726573756D6543616C6C6261636B2C2074727565293B0A20202020202020202020202020202020202020207D0A2020';
wwv_flow_imp.g_varchar2_table(40) := '20202020202020202020202020207D0A2020202020202020202020207D0A2020202020202020293B0A202020207D0A0A202020202F2F205075626C6963204150490A2020202072657475726E207B0A202020202020202072656E6465723A2072656E6465';
wwv_flow_imp.g_varchar2_table(41) := '720A202020207D3B0A0A7D2928293B';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(131037907855494855966)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_file_name=>'pretiusLoadJSONObject.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '76617220707265746975734C6F61644A534F4E4F626A6563743D7B72656E6465723A66756E6374696F6E2865297B76617220722C743D652C6E3D742E616374696F6E2E61747472696275746530362C693D742E616374696F6E2E61747472696275746530';
wwv_flow_imp.g_varchar2_table(2) := '372C613D742E616374696F6E2E61747472696275746530382C6F3D742E616374696F6E2E61747472696275746530392C633D742E616374696F6E2E61747472696275746531303B613D617065782E7574696C2E746F417272617928612C222C22292E6D61';
wwv_flow_imp.g_varchar2_table(3) := '702828653D3E2223222B652E7472696D28292E746F557070657243617365282929292E6A6F696E28222C22292C2259223D3D63262628723D617065782E7574696C2E73686F775370696E6E657228742E74726967676572696E67456C656D656E7429292C';
wwv_flow_imp.g_varchar2_table(4) := '617065782E7365727665722E706C7567696E28742E616374696F6E2E616A61784964656E7469666965722C7B706167654974656D733A617D2C7B64617461547970653A226A736F6E222C737563636573733A66756E6374696F6E2865297B69662866756E';
wwv_flow_imp.g_varchar2_table(5) := '6374696F6E28652C72297B666F722876617220743D28723D722E73706C697428222E2229292E6C656E6774682D312C6E3D303B6E3C743B2B2B6E297B76617220693D725B6E5D3B6920696E20657C7C28655B695D3D7B7D292C653D655B695D7D7D287769';
wwv_flow_imp.g_varchar2_table(6) := '6E646F772C6E292C2259223D3D3D69297B76617220613D28633D6E2E73706C697428222E2229292E706F7028293B28753D632E726564756365282866756E6374696F6E28652C72297B72657475726E20655B725D7D292C77696E646F7729292626612069';
wwv_flow_imp.g_varchar2_table(7) := '6E2075262664656C65746520755B615D7D76617220632C752C733B696628613D28633D6E2E73706C697428222E2229292E706F7028292C28753D632E726564756365282866756E6374696F6E28652C72297B72657475726E20655B725D7D292C77696E64';
wwv_flow_imp.g_varchar2_table(8) := '6F7729295B615D3D755B615D7C7C7B7D2C4F626A6563742E61737369676E28755B615D2C65292C722626722E72656D6F766528292C6F297472797B733D742C6E65772046756E6374696F6E282272657475726E202866756E6374696F6E202829207B5C6E';
wwv_flow_imp.g_varchar2_table(9) := '222B6F2B225C6E7D29222928292E63616C6C2873297D63617463682865297B636F6E736F6C652E6572726F7228224576696C20657865637574696F6E206572726F723A222C65297D742E616374696F6E2E77616974466F72526573756C74262661706578';
wwv_flow_imp.g_varchar2_table(10) := '2E64612E726573756D6528742E726573756D6543616C6C6261636B2C2131297D2C6572726F723A66756E6374696F6E28652C692C61297B722626722E72656D6F766528292C636F6E736F6C652E6572726F7228224A534F4E204C6F6164204572726F7220';
wwv_flow_imp.g_varchar2_table(11) := '666F72207661726961626C653A20222B6E2C692C61292C742E616374696F6E2E77616974466F72526573756C742626617065782E64612E726573756D6528742E726573756D6543616C6C6261636B2C2130297D7D297D7D3B';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(132408958194463465258)
,p_plugin_id=>wwv_flow_imp.id(130707185213027823646)
,p_file_name=>'pretiusLoadJSONObject.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done

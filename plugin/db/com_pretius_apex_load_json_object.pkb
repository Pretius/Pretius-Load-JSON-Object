create or replace package body com_pretius_apex_load_json_obj
as

    function render
        ( p_dynamic_action in apex_plugin.t_dynamic_action
        , p_plugin         in apex_plugin.t_plugin
        )
    return apex_plugin.t_dynamic_action_render_result
    as
        l_result                    apex_plugin.t_dynamic_action_render_result;
        l_javascript_variable       varchar2(4000) := p_dynamic_action.attribute_06;
        --surrounded by quotes as it will be used a parameter
        l_js_literal                varchar2(4000) := apex_escape.js_literal(l_javascript_variable , '"' );
        --not surrounded by quotes, as it will be on the left side of an assignment
        l_js_literal_with_window    varchar2(4000) := apex_escape.js_literal('window.' || l_javascript_variable, null);
    begin
        -- Debug
        apex_plugin_util.debug_dynamic_action
            ( p_plugin         => p_plugin
            , p_dynamic_action => p_dynamic_action
            );

        
        -- Generate Client-Side JavaScript
        l_result.javascript_function := apex_string.format(q'[
        function() {
            pretiusLoadJSONObject.render(this)
        }
        ]', 
            apex_escape.js_literal(l_js_literal_with_window)
        );

        -- Settings
        l_result.attribute_01 := p_dynamic_action.attribute_01;
        l_result.attribute_02 := p_dynamic_action.attribute_02;
        l_result.attribute_03 := p_dynamic_action.attribute_03;
        l_result.attribute_04 := p_dynamic_action.attribute_04;
        l_result.attribute_05 := p_dynamic_action.attribute_05;
        l_result.attribute_06 := l_js_literal_with_window;
        l_result.attribute_07 := p_dynamic_action.attribute_07;
        l_result.attribute_08 := p_dynamic_action.attribute_08;
        l_result.attribute_09 := p_dynamic_action.attribute_09;
        l_result.attribute_10 := p_dynamic_action.attribute_10;

        -- Result
        l_result.ajax_identifier := apex_plugin.get_ajax_identifier;  

        return l_result;
    end render;

    function ajax
        ( p_dynamic_action in apex_plugin.t_dynamic_action
        , p_plugin         in apex_plugin.t_plugin
        )
    return apex_plugin.t_dynamic_action_ajax_result
    as
        l_result apex_plugin.t_dynamic_action_ajax_result;

        l_source                  p_dynamic_action.attribute_01%TYPE DEFAULT p_dynamic_action.attribute_01;
        l_sql                     p_dynamic_action.attribute_02%TYPE DEFAULT p_dynamic_action.attribute_02;
        l_json_sql                p_dynamic_action.attribute_03%TYPE DEFAULT p_dynamic_action.attribute_03;
        l_plsql_json              p_dynamic_action.attribute_04%TYPE DEFAULT p_dynamic_action.attribute_04;
        l_static_json             p_dynamic_action.attribute_05%TYPE DEFAULT p_dynamic_action.attribute_05;
        
        l_clob                    clob;
        l_json_clob               clob;
    begin
        -- Debug
        apex_plugin_util.debug_dynamic_action
            ( p_plugin         => p_plugin
            , p_dynamic_action => p_dynamic_action
            );

        -- Generate the JSON Data based on source type
        case l_source
            when 'sql' then
                declare
                    l_context apex_exec.t_context;
                begin
                    l_context := apex_exec.open_query_context(
                        p_location          => apex_exec.c_location_local_db,
                        p_sql_query         => l_sql,
                        p_auto_bind_items   => true
                    );
                    
                    apex_json.initialize_clob_output(p_indent => 0);
                    apex_json.open_array;
                    apex_json.write_context(l_context);
                    apex_json.close_array;
                    
                    apex_exec.close(l_context);
                    
                    l_json_clob := apex_json.get_clob_output;
                    apex_json.free_output;
                    
                    apex_util.prn( p_clob => l_json_clob, p_escape => false );
                exception
                    when others then
                        apex_exec.close(l_context);
                        apex_json.free_output;
                        raise;
                end;

            when 'jsonsql' then
                declare
                    l_column_value_list apex_plugin_util.t_column_value_list;
                begin
                    l_column_value_list := apex_plugin_util.get_data(
                        p_sql_statement  => l_json_sql,
                        p_min_columns    => 1,
                        p_max_columns    => 1,
                        p_component_name => p_dynamic_action.name
                    );
                    
                    if l_column_value_list.exists(1) and l_column_value_list(1).count > 0 then
                        l_clob := l_column_value_list(1)(1);
                    end if;

                    if l_clob is not null then
                        apex_util.prn( p_clob => l_clob, p_escape => false );
                    else
                        apex_util.prn('{}');
                    end if;
                exception
                    when no_data_found then
                        apex_util.prn('{}');
                end;
                
            when 'plsql' then
                apex_json.initialize_clob_output(p_indent => 0);
                apex_plugin_util.execute_plsql_code( p_plsql_code => l_plsql_json );
                
                l_json_clob := apex_json.get_clob_output;
                apex_json.free_output;
                
                apex_util.prn( p_clob => l_json_clob, p_escape => false );
                
            when 'static' then
                apex_util.prn( p_clob => l_static_json, p_escape => false );
        end case;

        return l_result;
    end ajax;

end com_pretius_apex_load_json_obj;
/

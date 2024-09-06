{%- macro ensmble_vlt(source_model=none, hashed_columns=none, derived_columns=none, null_columns=none, include_source_columns=true) -%}

    {%- if source_model is none -%}
        {%- set error_message = "Error: source_model must be provided." -%}
        {{ exceptions.raise_compiler_error(error_message) }}
    {%- endif -%}

    {%- set source_model = ref(source_model) -%}

    {%- set all_source_columns = vault.source_columns(source_relation=source_model) -%}

    {%- set final_columns_to_select = [] -%}

    {%- if include_source_columns -%}
        {%- set final_columns_to_select = final_columns_to_select + all_source_columns -%}
    {%- endif -%}

    {%- if null_columns is not none -%}
        {%- set final_columns_to_select = final_columns_to_select + null_columns | list -%}
    {%- endif -%}

    {%- if derived_columns is not none -%}
        {%- set final_columns_to_select = final_columns_to_select + derived_columns | list -%}
    {%- endif -%}


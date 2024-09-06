{%- macro ensmble_vlt(source_model=none, hashed_columns=none, derived_columns=none, null_columns=none, include_source_columns=true) -%}

    {%- if source_model is none -%}
        {%- set error_message = "Error: source_model must be provided." -%}
        {{ exceptions.raise_compiler_error(error_message) }}
    {%- endif -%}

    {%- set source_model = ref(source_model) -%}

    {#-- Select columns from the source --#}
    {%- set all_source_columns = source_columns(source_relation=source_model) -%}

   
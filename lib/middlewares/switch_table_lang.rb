module PokerkingApi
  SUPPORT_HEADER_LANG = %w(zh en tc).freeze
  SWITCH_MODEL_LIST = %w(Info).freeze

  class SwitchTableLang
    def initialize(app)
      @app = app
    end

    def call(env)
      lang = env['HTTP_X_LANG'].to_s.strip
      lang = 'zh' unless SUPPORT_HEADER_LANG.include?(lang)
      switch_lang lang
      @app.call(env)
    end

    private

    def switch_lang(lang)
      lang.eql?('zh') ? switch_table_zh : switch_table_ln(lang)
    end

    def switch_table_zh
      origin_table
    end

    def switch_table_ln(lang)
      target_table lang
    end

    def origin_table
      SWITCH_MODEL_LIST.collect do |t|
        t.safe_constantize.table_name = t.underscore.pluralize
      end
    end

    def target_table(lang)
      SWITCH_MODEL_LIST.collect do |t|
        t.safe_constantize.table_name = "#{t.underscore}_#{lang.pluralize}"
      end
    end
  end
end
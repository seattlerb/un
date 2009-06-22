require 'rubygems'
require 'inline'

class Un
  VERSION = '1.0.0'
end

class Object
  inline(:C) do |builder|
    builder.prefix <<-EOC
      #ifndef RCLASS_SUPER
        #define RCLASS_IV_TBL(c) (RCLASS(c)->iv_tbl)
        #define RCLASS_M_TBL(c) (RCLASS(c)->m_tbl)
        #define RCLASS_SUPER(c) (RCLASS(c)->super)
      #endif

      void untweak(VALUE mod, VALUE c) {
        VALUE p = Qnil;
        for (; c; p = c, c = RCLASS_SUPER(c)) {
          if (c == mod || RCLASS_M_TBL(c) == RCLASS_M_TBL(mod)) {
            RCLASS_SUPER(p) = RCLASS_SUPER(c);
            rb_clear_cache();
            return;
          }
        }
      }
    EOC

    builder.c <<-EOC
      void unextend(VALUE mod) {
        untweak(mod, rb_singleton_class(self));
      }
    EOC
  end
end

class Module
  inline(:C) do |builder|
    builder.prefix "void untweak(VALUE mod, VALUE c);"

    builder.c <<-EOC
      void uninclude(VALUE mod) {
        untweak(mod, self);
      }
    EOC
  end
end

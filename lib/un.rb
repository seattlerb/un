require 'rubygems'
require 'inline'

class Un
  VERSION = '1.0.0'
end

class Object
  inline(:C) do |builder|
    builder.prefix <<-EOC
      void untweak(VALUE mod, VALUE c) {
        VALUE p;
        for (; c; p = c, c = RCLASS(c)->super) {
          if (c == mod || RCLASS(c)->m_tbl == RCLASS(mod)->m_tbl) {
            RCLASS(p)->super = RCLASS(c)->super;
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
    builder.c <<-EOC
      void uninclude(VALUE mod) {
        untweak(mod, self);
      }
    EOC
  end
end

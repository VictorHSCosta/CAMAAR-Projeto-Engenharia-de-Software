#include <psych.h>

VALUE cPsychVisitorsToRuby;

/* call-seq: vis.build_exception(klass, message)
 *
 * Create an exception with class +klass+ and +message+
 */
static VALUE build_exception(VALUE self, VALUE klass, VALUE mesg)
{
    VALUE e = rb_obj_alloc(klass);

    rb_iv_set(e, "mesg", mesg);

    return e;
}

/* call-seq: vis.path2class(path)
 *
 * Convert +path+ string to a class
 */
static VALUE path2class(VALUE self, VALUE path)
{
    return rb_path_to_class(path);
}

static VALUE init_struct(VALUE self, VALUE data, VALUE attrs)
{
    VALUE args = rb_ary_new2(1);
    rb_ary_push(args, attrs);
    rb_struct_initialize(data, args);

    return data;
}

void Init_psych_to_ruby(void)
{
    VALUE psych     = rb_define_module("Psych");
    VALUE class_loader  = rb_define_class_under(psych, "ClassLoader", rb_cObject);

    VALUE visitors  = rb_define_module_under(psych, "Visitors");
    VALUE visitor   = rb_define_class_under(visitors, "Visitor", rb_cObject);
    cPsychVisitorsToRuby = rb_define_class_under(visitors, "ToRuby", visitor);

    rb_define_private_method(cPsychVisitorsToRuby, "init_struct", init_struct, 2);
    rb_define_private_method(cPsychVisitorsToRuby, "build_exception", build_exception, 2);
    rb_define_private_method(class_loader, "path2class", path2class, 1);
}

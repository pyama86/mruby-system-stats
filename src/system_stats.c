#include <mruby.h>
#include <mruby/string.h>
#include <string.h>
#include <unistd.h>

#define ACCEPT_VIRTUAL_DEVICES TRUE
#define SYSFS_BLOCK "/sys/block"

static mrb_value mruby_is_device(mrb_state *mrb, mrb_value self)
{
  char syspath[PATH_MAX];
  char *slash;
  char *name;
  mrb_value value_name;

  mrb_get_args(mrb, "S", &value_name);
  name = mrb_str_to_cstr(mrb, value_name);

  /* Some devices may have a slash in their name (eg. cciss/c0d0...) */
  while ((slash = strchr(name, '/'))) {
    *slash = '!';
  }
  snprintf(syspath, sizeof(syspath), "%s/%s", SYSFS_BLOCK, name);

  if(access(syspath, F_OK) == 0)
    return mrb_true_value();

  return mrb_nil_value();
}

void mrb_mruby_system_stats_gem_init(mrb_state *mrb)
{
  struct RClass *mLinux;
  struct RClass *cDisk;
  struct RClass *mStats;
  struct RClass *cBase;
  mStats = mrb_define_module(mrb, "Stats");
  mLinux = mrb_define_module_under(mrb, mStats, "Linux");
  cBase = mrb_define_class_under(mrb, mLinux, "Base", mrb->object_class);
  cDisk = mrb_define_class_under(mrb, mLinux, "Disk", cBase);
  mrb_define_class_method(mrb, cDisk, "device?", mruby_is_device, MRB_ARGS_REQ(1));
}
void mrb_mruby_system_stats_gem_final(mrb_state *mrb)
{
}

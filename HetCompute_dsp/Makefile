#always first
include glue/defines.min

ifneq (,$(findstring hexagon,$(V_TARGET)))
  include hexagon.min
else
  include $(V_TARGET).min
endif

#always last
include $(RULES_MIN)

.PHONY: esp-idf
esp-idf:
	mkdir -p $(DESTDIR)
	cp -R * $(DESTDIR)


DESTDIR_INCLUDEPATH =

COMPONENT_DIR = components
COMPONENTS := $(dir $(wildcard $(COMPONENT_DIR)/*/component.mk))
COMPONENTS :=  $(filter-out $(COMPONENT_DIR)/esp32/,$(COMPONENTS))
COMPONENTS := $(foreach\
	comp,\
	$(COMPONENTS),\
	$(eval COMPONENT_ADD_INCLUDEDIRS="include")$(eval include $(comp)component.mk)$(foreach idir, $(COMPONENT_ADD_INCLUDEDIRS), $(comp)$(idir))\
)

define MakeInclude
cp -r $(1)/* $(DESTDIR);
endef

DUMMY := $(foreach\
	comp,\
	$(COMPONENTS),\
	$(call MakeInclude,$(comp))\
)

.PHONY: esp-idf
esp-idf-headers:
	@echo $(COMPONENTS)
	@echo $(DUMMY)
	cp sdkconfig.h $(DESTDIR)

.PHONY: gen-config
gen-config:
	export IDF_PATH=`pwd`
	make -f make/project.mk menuconfig
	cp make/build/include/sdkconfig.h .
EXECUTABLES = convolution_color convolution_color_problem2
CC=gcc49

all: $(EXECUTABLES)

LDFLAGS += $(foreach librarydir,$(subst :, ,$(LD_LIBRARY_PATH)),-L$(librarydir))

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
  LDFLAGS += -lrt -lOpenCL -lm
  CFLAGS += -Wall -std=gnu99 -g -O2
endif
ifeq ($(UNAME_S),Darwin)
  LDFLAGS +=  -framework OpenCL -lm
  CFLAGS += -Wall -std=c99 -g -O2
endif

ifdef OPENCL_INC
  CPPFLAGS = -I$(OPENCL_INC)
endif

ifdef OPENCL_LIB
  LDFLAGS = -L$(OPENCL_LIB)
endif

convolution_color.o: convolution_color.c cl-helper.h timing.h
convolution_color_problem2.o: convolution_color_problem2.c cl-helper.h timing.h
cl-helper.o: cl-helper.c cl-helper.h
ppma_io.o: ppma_io.c ppma_io.h

convolution_color: convolution_color.o ppma_io.o cl-helper.o
convolution_color_problem2: convolution_color_problem2.o ppma_io.o cl-helper.o

clean:
	rm -f $(EXECUTABLES) *.o

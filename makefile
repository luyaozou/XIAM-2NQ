# Makefile XIAM  (H.Hartwig  Mai 1996)
        FC = gfortran
    FFLAGS = -O2 -static # -O2 # # -g -C # -O2 -funroll-loops -m486 -fexpensive-optimizations -fstrength-reduce # 
      SRCS = memory_pool.f90 iam.f iamm.f iamv.f iamv2.f iamio.f iamint.f iamfit.f iamadj.f iamsys.f
      OBJS = $(addsuffix .o, $(basename $(SRCS)))
    LIBSRC = mgetx.f iamlib.f 
    LIBOBJ = $(addsuffix .o, $(basename $(LIBSRC)))
   EXENAME = xiam

       LOCAL_LIBS = -ldiv

  LOCAL_LIBS_PATH = -L../../lib -L../lib -L./lib

# track OS
CURRENT_OS = $(if $(OS),$(OS),Linux)
OS_TRACKER = .build_os_$(CURRENT_OS)

ifeq ($(OS), Windows)
	FC = x86_64-w64-mingw32-gfortran
	FFLAGS = -O2 -static
	OBJS = $(addsuffix .win.o, $(basename $(SRCS)))
	LIBOBJ = $(addsuffix .win.o, $(basename $(LIBSRC)))
	EXENAME = xiam.exe
endif

iam:     $(OBJS) $(LIBOBJ)
	$(FC) $(FFLAGS) -o $(EXENAME) $(OBJS) $(LIBOBJ) 

#iam:     $(OBJS) 
#	$(FC) -o $(EXENAME) $(OBJS) $(LOCAL_LIBS) $(LOCAL_LIBS_PATH)

memory_pool.o memory_pool.win.o: memory_pool.f90

iam.o iam.win.o:   iam.f iam.fi iamdata.fi memory_pool.f90

iamio.o iamio.win.o:  iamio.f iam.fi iamdata.fi

iamint.o iamint.win.o:  iamint.f iam.fi

iamadj.o iamadj.win.o:  iamadj.f iam.fi

iamm.o iamm.win.o:  iamm.f iam.fi

iamv.o iamv.win.o:  iamv.f iam.fi

iamv2.o iamv2.win.o: iamv2.f iam.fi

iamfit.o iamfit.win.o: iamfit.f iam.fi

mgetx.o : mgetx.f mgetx.fi


%.o: %.f
	$(FC) $(FFLAGS) -c $< -o $@

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

%.win.o: %.f
	$(FC) $(FFLAGS) -c $< -o $@

%.win.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

# deal with module file
$(OS_TRACKER):
	@rm -f .build_os_* *.mod
	@touch $@

memory_pool.o: $(OS_TRACKER)
memory_pool.win.o: $(OS_TRACKER)

# avoid cyclic dependence
$(filter-out memory_pool.o, $(OBJS)): memory_pool.o
$(filter-out memory_pool.win.o, $(OBJS)): memory_pool.win.o

#    for SGI   
#iamv.o : iamv.f iam.fi
#	gfortran -c -SWP:=ON iamv.f

# Use: make install INSTALL_DIR=/usr/local/bin  (requires sudo)
# or:  make install INSTALL_DIR=~/.local/bin    (user-specific)
# or:  make install                             (defaults to /usr/local/bin)
INSTALL_DIR ?= /usr/local/bin

install: 
	@echo "installing $(EXENAME) in $(INSTALL_DIR)"
	@mkdir -p $(INSTALL_DIR)
	@if [ "$(INSTALL_DIR)" = "/usr/local/bin" ]; then \
		sudo cp $(EXENAME) $(INSTALL_DIR) && \
		sudo chmod 755 $(INSTALL_DIR)/$(EXENAME) && \
		echo "installed $(EXENAME) in $(INSTALL_DIR) (system-wide)"; \
	else \
		cp $(EXENAME) $(INSTALL_DIR) && \
		chmod 755 $(INSTALL_DIR)/$(EXENAME) && \
		echo "installed $(EXENAME) in $(INSTALL_DIR) (user-specific)"; \
	fi
	@if [ "$(INSTALL_DIR)" = "~/.local/bin" ]; then \
		echo "Note: Make sure ~/.local/bin is in your PATH"; \
		echo "You can add it by adding 'export PATH=\$$HOME/.local/bin:\$$PATH' to your .bashrc"; \
	fi

clean:
	rm -f $(OBJS) $(LIBOBJ) $(EXENAME) *.mod .build_os_*

clean-all:
	rm -f $(OBJS) $(LIBOBJ) $(EXENAME) *.o *.mod .build_os_* *.a *.so *~ core* 

uninstall:
	@echo "uninstalling $(EXENAME) from $(INSTALL_DIR)"
	@if [ "$(INSTALL_DIR)" = "/usr/local/bin" ]; then \
		sudo rm -f $(INSTALL_DIR)/$(EXENAME) && \
		echo "uninstalled $(EXENAME) from $(INSTALL_DIR) (system-wide)"; \
	else \
		rm -f $(INSTALL_DIR)/$(EXENAME) && \
		echo "uninstalled $(EXENAME) from $(INSTALL_DIR) (user-specific)"; \
	fi

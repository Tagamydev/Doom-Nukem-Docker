all:
ifeq ($(OS),Windows_NT)
	echo "Building Doom-Nukem for Windows..."
else

	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		echo "Building Doom-Nukem for Linux..."
	else
		echo "Sorry, your system is not supported."
	endif
	
endif

clean:
ifeq ($(OS),Windows_NT)
	echo "cleaning containers Windows..."
else

	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		echo "cleaning containers Linux..."
	endif
	
endif

fclean: clean
ifeq ($(OS),Windows_NT)
	echo "cleaning everithing Windows..."
else

	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		echo "cleaning everithing Linux..."
	endif
	
endif

.PHONY: all fclean clean
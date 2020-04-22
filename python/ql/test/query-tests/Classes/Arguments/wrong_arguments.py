# Test cases corresponding to /Expressions/Arguments/wrong_arguments.py

class F0(object):
    def __init__(self, x):
        pass

class F1(object):
    def __init__(self, x, y = None):
        pass

class F2(object):
    def __init__(self, x, *y):
        pass

class F3(object):
    def __init__(self, x, y = None, *z):
        pass

class F4(object):
    def __init__(self, x, **y):
        pass

class F5(object):
    def  __init__(self, x, y = None, **z):
        pass

class F6(object):
    def  __init__(self, x, y):
        pass

class F7(object):
    def  __init__(self, x, y, z):
        pass

# Too few arguments

F0()
F1()
F2()
F3()
F4()
F5()
F6(1)
F7(1,2)

#Too many arguments

F0(1,2)
F1(1,2,3)
F5(1,2,3)
F6(1,2,3)
F6(1,2,3,4)

#OK

#Not too few
F7(*t)

#Not too many

F2(1,2,3,4,5,6)


#Illegal name
F0(y=1)
F1(z=1)
F2(x=0, y=1)


#Ok name
F0(x=0)
F1(x=0, y=1)
F4(q=4)

#This is correct, but a bit weird.
F6(**{'x':1, 'y':2})

t2 = (1,2)
t3 = (1,2,3)

#Ok
f(*t2)

#Too many
F6(*(1,2,3))
F6(*t3)

#Ok
F6(**{'x':1, 'y':2})

#Illegal name
F6(**{'x':1, 'y':2, 'z':3})


# Example code from https://github.com/Semmle/ql/issues/2445

class Meta(type):
    def __call__(cls, *args, **kwargs):
        print('creating an instance of', cls, 'without calling its __init__')
        print('args:', args)
        print('kwargs:', kwargs)
        return cls.__new__(cls)

class A(metaclass=Meta):
    def __init__(self):
        print('should never be called')

a = A(1, 2, 3, a=4, b=5, c=6)




class BaseConfigurableMetaClass(type, abc.ABC):
    def __new__(cls, name, bases, props, module=None):
        # Create the class
        cls = super(BaseConfigurableMetaClass, cls).__new__(
            cls, name, bases, props
        )
        # Wrap __init__
        setattr(cls, "__init__", cls.wrap(cls.__init__))
        return cls


    @classmethod
    def wrap(cls, func):
        """
        If a subclass of BaseConfigurable is passed keyword arguments, convert
        them into the instance of the CONFIG class.
        """


        @functools.wraps(func)
        def wrapper(self, config: Optional[BaseConfig] = None, **kwargs):
            if config is not None and len(kwargs):
                raise ConfigAndKWArgsMutuallyExclusive
            elif config is None and hasattr(self, "CONFIG") and kwargs:
                try:
                    config = self.CONFIG(**kwargs)
                except TypeError as error:
                    error.args = (
                        error.args[0].replace(
                            "__init__", f"{self.CONFIG.__qualname__}"
                        ),
                    )
                    raise
            if config is None:
                raise TypeError(
                    "__init__() missing 1 required positional argument: 'config'"
                )
            return func(self, config)


        return wrapper




class BaseConfigurable(metaclass=BaseConfigurableMetaClass):
    """
    Class which produces a config for itself by providing Args to a CMD (from
    dffml.util.cli.base) and then using a CMD after it contains parsed args to
    instantiate a config (deriving from BaseConfig) which will be used as the
    only parameter to the __init__ of a BaseDataFlowFacilitatorObject.
    """


    def __init__(self, config: Type[BaseConfig]) -> None:
        """
        BaseConfigurable takes only one argument to __init__,
        its config, which should inherit from BaseConfig. It shall be a object
        containing any information needed to configure the class and it's child
        context's.
        """
        self.config = config
        str_config = str(self.config)
        self.logger.debug(
            str_config if len(str_config) < 512 else (str_config[:512] + "...")
        )
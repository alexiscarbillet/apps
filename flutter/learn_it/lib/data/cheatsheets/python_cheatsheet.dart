import '../../models/cheatsheet.dart';

final Cheatsheet pythonCheatsheet = Cheatsheet(
  category: 'Python',
  summary: 'Core Python concepts including OOP features, decorators, generators, list comprehensions, and data structures.',
  sections: [
    CheatsheetSection(
      title: 'Decorators & Generators',
      content: 'Advanced Python features that enable modular code modifications and memory-efficient iterations. These are especially useful when writing reusable libraries or processing large streams of data.',
      bulletPoints: [
        'Decorators: Functions that modify the behavior of another function without altering its core source code. Commonly used for logging, auth, and timing.',
        'Generators: Functions that yield values one at a time using the `yield` keyword, maintaining state between yields. Highly memory efficient for massive datasets.',
        'Lazy Evaluation: Generators evaluate items on-demand, whereas standard lists load all elements into RAM.',
        'Closure: A nested function that captures variables from its enclosing scope, often used with decorators.',
        'Iterator Protocol: Objects implementing `__iter__` and `__next__` can be consumed with `for` loops.',
      ],
      codeSnippet: 'def log_decorator(func):\n    def wrapper(*args, **kwargs):\n        print(f"Calling {func.__name__}")\n        return func(*args, **kwargs)\n    return wrapper\n\n@log_decorator\ndef greet(name):\n    return f"Hello {name}"\n\n# Generator Example:\ndef count_up_to(n):\n    i = 1\n    while i <= n:\n        yield i\n        i += 1',
    ),
    CheatsheetSection(
      title: 'OOP & Dunder Methods',
      content: 'Python supports Object-Oriented Programming (OOP) classes, relying on Double Underscore (Dunder) magic methods for internal operator definitions. OOP helps organize complex systems into reusable, well-structured components.',
      bulletPoints: [
        '__init__: Constructor method, initializes instance variables upon instantiation.',
        '__str__: Developer-friendly string representation, invoked by `print()` or `str()`.',
        '__repr__: Unambiguous representation of the object, used for debugging and logging.',
        'Inheritance: Subclasses inherit attributes and methods from parent classes, invoking `super().__init__()` to call parent constructors.',
        'Encapsulation: Bundling data and behavior together while controlling access via methods or properties.',
        'Polymorphism: Different classes can implement the same interface or method name in their own way.',
      ],
      codeSnippet: 'class Book:\n    def __init__(self, title, author):\n        self.title = title\n        self.author = author\n\n    def __str__(self):\n        return f"\'{self.title}\' by {self.author}"\n\n    def __repr__(self):\n        return f"Book(title=\'{self.title}\', author=\'{self.author}\')"',
    ),
    CheatsheetSection(
      title: 'Comprehensions & Lambdas',
      content: 'Syntactic shortcuts that yield concise, highly readable declarations of lists, dicts, and anonymous functions. They are a strong Python idiom for writing compact yet expressive code.',
      bulletPoints: [
        'List Comprehension: Syntactic sugar for generating lists: `[expression for item in iterable if condition]`.',
        'Lambda: Anonymous single-expression functions. Declared with `lambda arguments: expression`.',
        'Dict Comprehension: Create mappings from iterables using concise syntax, often for transformations or filtering.',
        'Set Comprehension: Similar to list comprehension but produces unique values.',
      ],
      codeSnippet: '# Create list of even squares\neven_squares = [x**2 for x in range(10) if x % 2 == 0]\n\n# Anonymous multiplier function\ndouble = lambda x: x * 2\nprint(double(5)) # Outputs 10',
    ),
    CheatsheetSection(
      title: 'Context Managers & Scope',
      content: 'Safe execution and automated resource cleanup mechanisms. Context managers are essential for files, sockets, and database connections because they prevent leaks and guarantee cleanup.',
      bulletPoints: [
        'with statement: Invokes a context manager to handle set up and teardown automatically.',
        '__enter__ and __exit__: Methods implemented on class objects to define resource acquisition and release behavior.',
        'Contextlib: Python standard library helpers such as `contextmanager` and `closing` simplify custom context managers.',
        'Scope Rules: LEGB (Local, Enclosing, Global, Built-in) determines where Python resolves names.',
      ],
      codeSnippet: '# Safely open and read a file (handles closing automatically)\nwith open("data.txt", "r") as file:\n    content = file.read()',
    ),
  ],
);

import '../../models/cheatsheet.dart';

final Cheatsheet pythonCheatsheet = Cheatsheet(
  category: 'Python',
  summary: 'Core Python concepts including OOP features, decorators, generators, list comprehensions, and data structures.',
  sections: [
    CheatsheetSection(
      title: 'Decorators & Generators',
      content: 'Advanced Python features that enable modular code modifications and memory-efficient iterations.',
      bulletPoints: [
        'Decorators: Functions that modify the behavior of another function without altering its core source code. Commonly used for logging, auth, and timing.',
        'Generators: Functions that yield values one at a time using the `yield` keyword, maintaining state between yields. Highly memory efficient for massive datasets.',
        'Lazy Evaluation: Generators evaluate items on-demand, whereas standard lists load all elements into RAM.',
      ],
      codeSnippet: 'def log_decorator(func):\n    def wrapper(*args, **kwargs):\n        print(f"Calling {func.__name__}")\n        return func(*args, **kwargs)\n    return wrapper\n\n@log_decorator\ndef greet(name):\n    return f"Hello {name}"\n\n# Generator Example:\ndef count_up_to(n):\n    i = 1\n    while i <= n:\n        yield i\n        i += 1',
    ),
    CheatsheetSection(
      title: 'OOP & Dunder Methods',
      content: 'Python supports Object-Oriented Programming (OOP) classes, relying on Double Underscore (Dunder) magic methods for internal operator definitions.',
      bulletPoints: [
        '__init__: Constructor method, initializes instance variables upon instantiation.',
        '__str__: Developer-friendly string representation, invoked by `print()` or `str()`.',
        '__repr__: Unambiguous representation of the object, used for debugging and logging.',
        'Inheritance: Subclasses inherit attributes and methods from parent classes, invoking `super().__init__()` to call parent constructors.',
      ],
      codeSnippet: 'class Book:\n    def __init__(self, title, author):\n        self.title = title\n        self.author = author\n\n    def __str__(self):\n        return f"\'{self.title}\' by {self.author}"\n\n    def __repr__(self):\n        return f"Book(title=\'{self.title}\', author=\'{self.author}\')"',
    ),
    CheatsheetSection(
      title: 'Comprehensions & Lambdas',
      content: 'Syntactic shortcuts that yield concise, highly readable declarations of lists, dicts, and anonymous functions.',
      bulletPoints: [
        'List Comprehension: Syntactic sugar for generating lists: `[expression for item in iterable if condition]`.',
        'Lambda: Anonymous single-expression functions. Declared with `lambda arguments: expression`.',
      ],
      codeSnippet: '# Create list of even squares\neven_squares = [x**2 for x in range(10) if x % 2 == 0]\n\n# Anonymous multiplier function\ndouble = lambda x: x * 2\nprint(double(5)) # Outputs 10',
    ),
    CheatsheetSection(
      title: 'Context Managers & Scope',
      content: 'Safe execution and automated resource cleanup mechanisms.',
      bulletPoints: [
        'with statement: Invokes a context manager to handle set up and teardown automatically.',
        '__enter__ and __exit__: Methods implemented on class objects to define resource acquisition and release behavior.',
      ],
      codeSnippet: '# Safely open and read a file (handles closing automatically)\nwith open("data.txt", "r") as file:\n    content = file.read()',
    ),
  ],
);

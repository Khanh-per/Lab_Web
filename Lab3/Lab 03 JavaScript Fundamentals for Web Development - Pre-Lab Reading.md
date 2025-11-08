---
title: Lab 03 JavaScript Fundamentals for Web Development - Pre-Lab Reading

---

# Lab 03 JavaScript Fundamentals for Web Development - Pre-Lab Reading
**Read before class** | **Duration:** 2.5 hours lab | **Points:** 100

## Lab Overview

**Objective:** Master JavaScript fundamentals through hands-on exercises building interactive web features.

**What You'll Build:** Dynamic web components including form validators, interactive games, data visualizers, and real-time features that bring websites to life.

**Learning Style:**
- 📖 **Read** sample code
- 🧠 **Understand** the concept
- ✏️ **Write** your own code based on examples
- 🚀 **Test** and see the results

---

## Setup (5 minutes)

### Create New Project
```bash
mkdir javascript-web-lab
cd javascript-web-lab
```

Create the following files:
- `index.html` - Main HTML file
- `style.css` - Styling
- `script.js` - JavaScript code

**Basic HTML Template (`index.html`):**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaScript Lab</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div id="app"></div>
    <script src="script.js"></script>
</body>
</html>
```

---

## Part 1: DOM Manipulation & Events

### 📖 Sample Code: Understanding DOM Manipulation

The Document Object Model (DOM) allows JavaScript to interact with and modify HTML elements.

**Create `dom-basics.html`:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DOM Basics</title>
    <style>
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            border: 2px solid #333;
            border-radius: 8px;
        }
        
        .task-item {
            padding: 10px;
            margin: 10px 0;
            background: #f0f0f0;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .completed {
            text-decoration: line-through;
            opacity: 0.6;
        }
        
        button {
            padding: 8px 16px;
            margin: 5px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
            background: #007bff;
            color: white;
        }
        
        button:hover {
            background: #0056b3;
        }
        
        input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 70%;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Simple Todo List</h1>
        
        <div>
            <input type="text" id="taskInput" placeholder="Enter a task...">
            <button onclick="addTask()">Add Task</button>
        </div>
        
        <div id="taskList"></div>
    </div>

    <script>
        // Array to store tasks
        let tasks = [];

        // Add a new task
        function addTask() {
            const input = document.getElementById('taskInput');
            const taskText = input.value.trim();
            
            if (taskText === '') {
                alert('Please enter a task!');
                return;
            }
            
            // Create task object
            const task = {
                id: Date.now(),
                text: taskText,
                completed: false
            };
            
            tasks.push(task);
            input.value = '';
            renderTasks();
        }

        // Toggle task completion
        function toggleTask(id) {
            const task = tasks.find(t => t.id === id);
            if (task) {
                task.completed = !task.completed;
                renderTasks();
            }
        }

        // Delete a task
        function deleteTask(id) {
            tasks = tasks.filter(t => t.id !== id);
            renderTasks();
        }

        // Render all tasks to the DOM
        function renderTasks() {
            const taskList = document.getElementById('taskList');
            
            if (tasks.length === 0) {
                taskList.innerHTML = '<p style="color: #999;">No tasks yet. Add one above!</p>';
                return;
            }
            
            taskList.innerHTML = tasks.map(task => `
                <div class="task-item ${task.completed ? 'completed' : ''}">
                    <span onclick="toggleTask(${task.id})" style="cursor: pointer; flex: 1;">
                        ${task.text}
                    </span>
                    <button onclick="deleteTask(${task.id})" 
                            style="background: #dc3545;">
                        Delete
                    </button>
                </div>
            `).join('');
        }

        // Initialize
        renderTasks();
    </script>
</body>
</html>
```

**Expected Output:**

When you open the file in a browser:
- You can add tasks by typing and clicking "Add Task"
- Click on a task to mark it complete (strikethrough)
- Click "Delete" to remove a task
- Tasks persist during the session

**Key Concepts:**
- `document.getElementById()` - Select elements
- `element.innerHTML` - Modify content
- Event handlers with `onclick`
- Array methods: `push()`, `filter()`, `find()`, `map()`
- Template literals for dynamic HTML

---

## Part 2: Asynchronous JavaScript

### 📖 Sample Code: Understanding Async/Await & Fetch API

Modern web applications fetch data from servers without reloading the page.

**Create `async-basics.html`:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Async JavaScript</title>
    <style>
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        
        .user-card {
            background: white;
            padding: 20px;
            margin: 10px 0;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .loading {
            text-align: center;
            font-size: 18px;
            color: #666;
        }
        
        button {
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>User Directory</h1>
        <button onclick="loadUsers()">Load Users</button>
        <div id="userList"></div>
    </div>

    <script>
        // Fetch users from API
        async function loadUsers() {
            const userList = document.getElementById('userList');
            
            // Show loading state
            userList.innerHTML = '<div class="loading">Loading users...</div>';
            
            try {
                // Fetch data from API
                const response = await fetch('https://jsonplaceholder.typicode.com/users');
                
                // Check if request was successful
                if (!response.ok) {
                    throw new Error('Failed to fetch users');
                }
                
                // Parse JSON data
                const users = await response.json();
                
                // Display users
                displayUsers(users);
                
            } catch (error) {
                userList.innerHTML = `<div class="error">Error: ${error.message}</div>`;
            }
        }

        function displayUsers(users) {
            const userList = document.getElementById('userList');
            
            userList.innerHTML = users.map(user => `
                <div class="user-card">
                    <h3>${user.name}</h3>
                    <p>Email: ${user.email}</p>
                    <p>Phone: ${user.phone}</p>
                    <p>Company: ${user.company.name}</p>
                </div>
            `).join('');
        }

        // Example with multiple async operations
        async function fetchUserPosts(userId) {
            try {
                // Fetch user and posts in parallel
                const [userResponse, postsResponse] = await Promise.all([
                    fetch(`https://jsonplaceholder.typicode.com/users/${userId}`),
                    fetch(`https://jsonplaceholder.typicode.com/posts?userId=${userId}`)
                ]);
                
                const user = await userResponse.json();
                const posts = await postsResponse.json();
                
                return { user, posts };
            } catch (error) {
                console.error('Error fetching data:', error);
            }
        }
    </script>
</body>
</html>
```

**Expected Output:**

When you click "Load Users":
```
User Directory
[Load Users]

Loading users...

(After 1-2 seconds)

John Doe
Email: john@example.com
Phone: 1-770-736-8031
Company: Romaguera-Crona

Jane Smith
Email: jane@example.com
Phone: 010-692-6593
Company: Deckow-Crist

...
```

**Key Concepts:**
- `async/await` - Modern way to handle asynchronous operations
- `fetch()` - Make HTTP requests
- `try...catch` - Error handling
- `Promise.all()` - Run multiple async operations in parallel
- Loading states - Show feedback while waiting

---

## Part 3: Advanced JavaScript Features

### 📖 Concept: ES6+ Features

**Key Features You Should Know:**

**1. Arrow Functions:**
```javascript
// Traditional function
function add(a, b) {
    return a + b;
}

// Arrow function
const add = (a, b) => a + b;

// With array methods
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
```

**2. Destructuring:**
```javascript
// Object destructuring
const user = { name: 'John', age: 30, email: 'john@example.com' };
const { name, age } = user;

// Array destructuring
const colors = ['red', 'green', 'blue'];
const [first, second] = colors;
```

**3. Spread Operator:**
```javascript
// Combine arrays
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];
const combined = [...arr1, ...arr2];

// Copy array
const original = [1, 2, 3];
const copy = [...original];

// Copy object
const user = { name: 'John', age: 30 };
const updatedUser = { ...user, age: 31 };
```

**4. Template Literals:**
```javascript
const name = 'John';
const age = 30;

// String interpolation
const message = `Hello, my name is ${name} and I'm ${age} years old.`;

// Multi-line strings
const html = `
    <div>
        <h1>${name}</h1>
        <p>Age: ${age}</p>
    </div>
`;
```

**5. Array Methods:**
```javascript
const users = [
    { id: 1, name: 'John', age: 30, active: true },
    { id: 2, name: 'Jane', age: 25, active: false },
    { id: 3, name: 'Bob', age: 35, active: true }
];

// Map - transform array
const names = users.map(user => user.name);
// Result: ['John', 'Jane', 'Bob']

// Filter - select items
const activeUsers = users.filter(user => user.active);
// Result: [{ id: 1, ...}, { id: 3, ...}]

// Find - get first match
const john = users.find(user => user.name === 'John');
// Result: { id: 1, name: 'John', age: 30, active: true }

// Reduce - accumulate value
const totalAge = users.reduce((sum, user) => sum + user.age, 0);
// Result: 90

// Some - check if any match
const hasInactive = users.some(user => !user.active);
// Result: true

// Every - check if all match
const allActive = users.every(user => user.active);
// Result: false

// Sort - order items
users.sort((a, b) => a.age - b.age);
```

**6. Promises and Async/Await:**
```javascript
// Creating a Promise
function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// Using async/await
async function example() {
    console.log('Starting...');
    await delay(1000);
    console.log('After 1 second');
    await delay(1000);
    console.log('After 2 seconds');
}

// Error handling
async function fetchData() {
    try {
        const response = await fetch('/api/data');
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error:', error);
        throw error;
    }
}
```

---

## Part 4: Local Storage & State Management

### 📖 Concept: Browser Storage

**localStorage API:**
```javascript
// Save data (strings only)
localStorage.setItem('username', 'John');

// Save objects (must stringify)
const user = { name: 'John', age: 30 };
localStorage.setItem('user', JSON.stringify(user));

// Retrieve data
const username = localStorage.getItem('username');

// Retrieve and parse objects
const userString = localStorage.getItem('user');
const user = JSON.parse(userString);

// Remove specific item
localStorage.removeItem('username');

// Clear all data
localStorage.clear();

// Check if key exists
if (localStorage.getItem('username')) {
    console.log('Username exists');
}
```

**Complete Example:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LocalStorage Example</title>
    <style>
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
        }
        
        input, button {
            padding: 10px;
            margin: 5px;
            font-size: 16px;
        }
        
        .saved-items {
            margin-top: 20px;
        }
        
        .item {
            padding: 10px;
            background: #f0f0f0;
            margin: 5px 0;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Shopping List (Persistent)</h1>
        
        <input type="text" id="itemInput" placeholder="Add item...">
        <button onclick="addItem()">Add</button>
        <button onclick="clearAll()">Clear All</button>
        
        <div class="saved-items" id="itemsList"></div>
    </div>

    <script>
        const STORAGE_KEY = 'shopping_list';

        // Load items from localStorage
        function loadItems() {
            const stored = localStorage.getItem(STORAGE_KEY);
            return stored ? JSON.parse(stored) : [];
        }

        // Save items to localStorage
        function saveItems(items) {
            localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
        }

        // Add new item
        function addItem() {
            const input = document.getElementById('itemInput');
            const text = input.value.trim();
            
            if (!text) return;
            
            const items = loadItems();
            items.push({
                id: Date.now(),
                text: text,
                addedAt: new Date().toISOString()
            });
            
            saveItems(items);
            input.value = '';
            renderItems();
        }

        // Delete item
        function deleteItem(id) {
            const items = loadItems();
            const filtered = items.filter(item => item.id !== id);
            saveItems(filtered);
            renderItems();
        }

        // Clear all items
        function clearAll() {
            if (confirm('Delete all items?')) {
                localStorage.removeItem(STORAGE_KEY);
                renderItems();
            }
        }

        // Render items to page
        function renderItems() {
            const items = loadItems();
            const container = document.getElementById('itemsList');
            
            if (items.length === 0) {
                container.innerHTML = '<p style="color: #999;">No items yet</p>';
                return;
            }
            
            container.innerHTML = items.map(item => `
                <div class="item">
                    <span>${item.text}</span>
                    <button onclick="deleteItem(${item.id})">Delete</button>
                </div>
            `).join('');
        }

        // Initialize on page load
        window.onload = renderItems;
    </script>
</body>
</html>
```

**Use Cases for localStorage:**
- Save user preferences (theme, language)
- Store shopping cart items
- Cache API responses
- Save game progress
- Remember form data
- Store authentication tokens

---

## Quick Reference Guide

### DOM Manipulation
```javascript
// Select elements
document.getElementById('id')
document.querySelector('.class')
document.querySelectorAll('div')

// Modify content
element.textContent = 'text'
element.innerHTML = '<strong>HTML</strong>'
element.value = 'input value'

// Modify attributes
element.setAttribute('data-id', '123')
element.classList.add('active')
element.classList.remove('hidden')
element.classList.toggle('visible')

// Create elements
const div = document.createElement('div')
div.textContent = 'Hello'
parent.appendChild(div)
```

### Event Handling
```javascript
// Add event listener
element.addEventListener('click', function(e) {
    console.log('Clicked!', e.target);
});

// Common events
'click', 'input', 'change', 'submit', 
'keypress', 'keydown', 'keyup',
'mouseenter', 'mouseleave', 'scroll'

// Event object properties
e.target        // Element that triggered event
e.preventDefault()  // Prevent default action
e.stopPropagation() // Stop event bubbling
```

### Array Methods
```javascript
// Map - transform array
const doubled = numbers.map(n => n * 2);

// Filter - select items
const evens = numbers.filter(n => n % 2 === 0);

// Reduce - accumulate value
const sum = numbers.reduce((total, n) => total + n, 0);

// Find - get first match
const user = users.find(u => u.id === 5);

// Some - check if any match
const hasAdmin = users.some(u => u.role === 'admin');

// Every - check if all match
const allActive = users.every(u => u.active);

// Sort - order items
users.sort((a, b) => a.name.localeCompare(b.name));
```

### Async/Await
```javascript
// Fetch API
async function getData() {
    try {
        const response = await fetch(url);
        const data = await response.json();
        return data;
    } catch (error) {
        console.error(error);
    }
}

// Promise.all - parallel requests
const [users, posts] = await Promise.all([
    fetch('/api/users').then(r => r.json()),
    fetch('/api/posts').then(r => r.json())
]);
```

---

## Common Mistakes to Avoid

### ❌ Mistake 1: Not Handling Async Errors
```javascript
// Wrong - no error handling
async function fetchData() {
    const response = await fetch(url);
    const data = await response.json();
    return data;
}
```

### ✅ Solution: Always use try-catch
```javascript
async function fetchData() {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching data:', error);
        showErrorMessage(error.message);
    }
}
```

### ❌ Mistake 2: Mutating State Directly
```javascript
// Wrong - mutates original array
function addItem(items, newItem) {
    items.push(newItem);
    return items;
}
```

### ✅ Solution: Create new copies
```javascript
function addItem(items, newItem) {
    return [...items, newItem];
}
```

### ❌ Mistake 3: Not Debouncing Input
```javascript
// Wrong - fires on every keystroke
input.addEventListener('input', (e) => {
    searchAPI(e.target.value); // Too many API calls!
});
```

### ✅ Solution: Debounce the function
```javascript
function debounce(func, delay) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), delay);
    };
}

input.addEventListener('input', debounce((e) => {
    searchAPI(e.target.value);
}, 500));
```

---

## Debugging Tips

### Using Console Methods
```javascript
// Basic logging
console.log('Message', variable);

// Table view for arrays
console.table(users);

// Timing code execution
console.time('operation');
// ... code ...
console.timeEnd('operation');

// Group related logs
console.group('User Details');
console.log('Name:', user.name);
console.log('Email:', user.email);
console.groupEnd();
```

### Browser DevTools Shortcuts

- `F12` or `Ctrl+Shift+I` - Open DevTools
- `Ctrl+Shift+C` - Inspect element
- Check **Console** tab for errors
- Use **Network** tab to monitor API requests
- Use **Application** tab to view localStorage

---

## Homework Tasks

These tasks will be completed as homework after the lab session. Detailed requirements will be provided during class.

### Task 3.1: Data Visualization Dashboard (15 points)
Build an interactive dashboard with charts and statistics.

### Task 3.2: Memory Card Game (15 points)
Create a memory matching game with scoring and timer.

### Task 4.1: Note-Taking App (10 points - Bonus)
Build a feature-rich note app with local storage and search.

---

## Preparation Checklist

Before coming to lab, make sure you:

- [ ] Read through all sample code examples
- [ ] Test the DOM manipulation example
- [ ] Test the async/await example
- [ ] Understand array methods (map, filter, reduce)
- [ ] Understand localStorage basics
- [ ] Have your development environment ready
- [ ] Have a code editor installed (VS Code recommended)
- [ ] Have a modern browser with DevTools

---

## Resources

### Official Documentation
- **MDN Web Docs**: https://developer.mozilla.org/
- **JavaScript.info**: https://javascript.info/

### Practice Platforms
- **FreeCodeCamp**: https://www.freecodecamp.org/
- **JavaScript30**: https://javascript30.com/

### APIs for Practice
- **JSONPlaceholder**: https://jsonplaceholder.typicode.com/
- **OpenWeatherMap**: https://openweathermap.org/api

---

**See you in class! Come prepared with questions! 🚀**

*End of Pre-Lab Reading Material*
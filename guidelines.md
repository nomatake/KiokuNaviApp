# ✅ AI Review Guidelines for Flutter Project (GetX Pattern)

## 🔍 Scope of Review

You are reviewing a Flutter project that uses the **GetX** package and follows the **GetX architectural pattern**. The app is being developed to support **responsive design** for **mobile and tablet devices**.

---

## 📋 Step-by-Step Instructions

### 1. Carefully Review All Relevant Files and Folders
- Go through each Dart file and directory **manually**, one by one.
- **Exclude** any **auto-generated files** (e.g., `.g.dart`, `.freezed.dart`, `.gen`, `.mocks`, etc.).

### 2. Inspect All Dependencies
- Review all the **packages used** in the project (`pubspec.yaml`).
- Identify any **unused** or **unnecessary** dependencies.
- Check if any packages can be **replaced** with simpler or more efficient alternatives without breaking functionality.

### 3. Follow the GetX Architecture Strictly
- Ensure proper separation between **Controllers**, **Views**, and **Bindings**.
- Verify that state management is handled using **GetBuilder**, **Obx**, or other GetX-compliant patterns appropriately.

### 4. Optimize Files Selectively
- Evaluate each file to see if **optimization is required**.
- Only suggest or make changes if they **enhance performance, readability, or maintainability**.
- Avoid unnecessary restructuring.

### 5. Maintain Backward Compatibility
- **Do not introduce breaking changes.**
- Any suggestion or fix should **preserve existing behavior**.
- Where change is necessary, suggest **non-breaking refactors** or **gradual improvements**.

### 6. Check for Potential Errors
- Identify possible runtime or logical errors.
- Look for **null safety issues**, **misused widgets**, or **incorrect reactive patterns**.
- Suggest or fix them **safely and clearly**.

### 7. Avoid Redundant Widgets or Code
- Detect widgets or structures that are **unnecessarily nested** or **repeated**.
- Recommend clean alternatives or utility widgets without breaking the layout.

### 8. Ensure Responsive Design Compatibility
- Verify that the layout works well on both **phones and tablets**.
- Suggest improvements for **adaptive sizing**, **media queries**, or **custom layout builders** if needed.

---

## 🧠 Additional AI Behavior Notes

- **Think deeply and contextually**. Don’t rely solely on surface-level checks.
- Be **precise** in suggestions and avoid vague recommendations.
- Keep the developer's **current patterns and conventions** in mind—respect the existing coding style.
- Output your findings and improvements **step-by-step**, per file, with justification.
- If something is not clear, ask for clarification instead of guessing.

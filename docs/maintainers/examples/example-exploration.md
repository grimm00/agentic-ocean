# Example: User Authentication - Exploration

**Status:** 🔴 Exploration  
**Created:** [Date]  
**Last Updated:** [Date]

---

## 🎯 What Are We Exploring?

<!-- 
  EXPLORATION PURPOSE:
  Describe what you're exploring - a new idea, proof of concept, or concept that needs investigation.
  Be clear about the scope and what you're trying to understand.
-->

Exploring options for implementing user authentication in our application. We need to understand what authentication methods are available, how they integrate with our tech stack, and what the implementation approach should be.

**Current State:**
- Application currently has no authentication
- Users access all features without login
- Need to add authentication for user-specific features
- Tech stack: [Your Tech Stack]

---

## 🤔 Why Explore This?

<!-- 
  PROBLEM STATEMENT:
  Explain why this exploration is needed. What problem are you trying to solve?
  What opportunity exists? What context is important?
-->

**Problem:** 
- Application needs user authentication for user-specific features
- Need to understand authentication options before implementation
- Want to make informed decision about authentication approach

**Opportunity:**
- Could improve user experience with personalized features
- Could enable user-specific data and preferences
- Could support future features requiring user identity

**Context:**
- This is a new feature, not replacing existing authentication
- Need to consider security, user experience, and implementation complexity
- Should align with existing tech stack and architecture

---

## 💡 Initial Thoughts

<!-- 
  INITIAL IDEAS:
  Document your initial thoughts, ideas, or hypotheses.
  What do you think might work? What are you unsure about?
  What exists already that might be relevant?
-->

**What we know:**
- Application uses [Tech Stack]
- Need to support [User Requirements]
- Security is important
- User experience should be smooth

**What we're unsure about:**
- Which authentication method to use (OAuth, JWT, session-based, etc.)
- How to integrate with existing architecture
- What user data we need to store
- How to handle password reset and account management

**What needs research:**
- Authentication methods available for our tech stack
- Security best practices
- User experience considerations
- Implementation complexity

---

## 🔍 Key Questions

<!-- 
  RESEARCH QUESTIONS:
  List the key questions that need to be researched.
  These questions will guide the research phase.
  Prioritize questions (High/Medium/Low) if helpful.
-->

- [ ] What authentication methods are available for our tech stack?
- [ ] What are the security considerations for each method?
- [ ] How do different methods compare in terms of user experience?
- [ ] What is the implementation complexity for each method?
- [ ] What user data do we need to store?
- [ ] How do we handle password reset and account management?
- [ ] What are the scalability considerations?
- [ ] How do we integrate authentication with existing features?

---

## 🚀 Next Steps

<!-- 
  WORKFLOW CONTINUATION:
  Document the next steps in the exploration → research → decision workflow.
  This helps users understand how to proceed after exploration.
-->

1. Review research topics listed above
2. Use `/research user-authentication --from-explore user-authentication` to conduct research
3. After research, use `/decision user-authentication --from-research` to make decisions
4. Use `/transition-plan --from-adr` to transition to feature planning

---

## 📝 Notes

<!-- 
  ADDITIONAL NOTES:
  Include any additional context, constraints, or information that might be helpful.
  This section can include technical details, constraints, or other relevant information.
-->

**Technical Context:**
- Application backend: [Backend Technology]
- Application frontend: [Frontend Technology]
- Database: [Database Technology]
- Deployment: [Deployment Environment]

**Constraints:**
- Must work with existing tech stack
- Must support [Specific Requirements]
- Must meet security requirements
- Must be maintainable

**Related Work:**
- [Link to related exploration/research/decision documents]
- [Link to related feature plans]

---

**Last Updated:** [Date]


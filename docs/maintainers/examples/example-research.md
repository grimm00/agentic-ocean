# Example: User Authentication Methods - Research

**Research Topic:** User Authentication  
**Question:** What authentication methods are available for our tech stack?  
**Status:** 🔴 Research  
**Created:** [Date]  
**Last Updated:** [Date]

---

## 🎯 Research Question

<!-- 
  RESEARCH QUESTION:
  State the specific question you're researching.
  This should be clear and focused on a single topic.
-->

What authentication methods are available for our tech stack? How do they compare in terms of security, user experience, and implementation complexity?

---

## 🔍 Research Goals

<!-- 
  RESEARCH GOALS:
  List what you want to learn from this research.
  These goals guide your research process.
-->

- [ ] Goal 1: Identify authentication methods available for [Tech Stack]
- [ ] Goal 2: Compare security features of each method
- [ ] Goal 3: Evaluate user experience of each method
- [ ] Goal 4: Assess implementation complexity

---

## 📚 Research Methodology

<!-- 
  RESEARCH METHODOLOGY:
  Document your research approach.
  What sources will you use? What methods will you employ?
-->

**Sources:**
- [ ] Source 1: Official documentation for [Tech Stack] authentication libraries
- [ ] Source 2: Security best practices documentation
- [ ] Source 3: User experience research and case studies
- [ ] Source 4: Implementation guides and tutorials

**Methods:**
- Review official documentation
- Analyze security features
- Compare user experience patterns
- Evaluate implementation examples

---

## 📊 Findings

<!-- 
  FINDINGS:
  Document your research findings with sources.
  Include analysis and comparisons where relevant.
  Be objective and cite sources.
-->

### Finding 1: OAuth 2.0 Authentication

**Finding:** OAuth 2.0 is available for [Tech Stack] via [Library Name].

**Key Features:**
- Industry-standard protocol
- Supports multiple providers (Google, GitHub, etc.)
- Secure token-based authentication
- Good user experience (social login)

**Security:**
- Uses secure token exchange
- Supports refresh tokens
- Industry-standard security practices

**User Experience:**
- Social login reduces friction
- Users familiar with OAuth flow
- No password management needed

**Implementation Complexity:**
- Medium complexity
- Requires OAuth provider setup
- Library handles most complexity

**Source:** [Official Documentation Link]

**Relevance:** Good option for applications wanting social login and reduced password management.

---

### Finding 2: JWT-Based Authentication

**Finding:** JWT (JSON Web Tokens) authentication is available via [Library Name].

**Key Features:**
- Stateless authentication
- Token-based approach
- Works well with APIs
- Customizable token payload

**Security:**
- Tokens can be signed and encrypted
- Stateless reduces server-side storage
- Need to handle token expiration properly

**User Experience:**
- Seamless for API clients
- Requires token refresh handling
- Good for single-page applications

**Implementation Complexity:**
- Low to medium complexity
- Requires token management
- Need to handle refresh tokens

**Source:** [Official Documentation Link]

**Relevance:** Good option for API-first applications and SPAs.

---

### Finding 3: Session-Based Authentication

**Finding:** Traditional session-based authentication is available via [Framework Name].

**Key Features:**
- Server-side session management
- Familiar pattern
- Good security with proper implementation
- Works well with server-rendered apps

**Security:**
- Sessions stored server-side
- CSRF protection available
- Secure cookie handling

**User Experience:**
- Traditional login flow
- Users familiar with pattern
- Works well with forms

**Implementation Complexity:**
- Low complexity
- Framework handles most details
- Well-documented pattern

**Source:** [Official Documentation Link]

**Relevance:** Good option for traditional web applications.

---

## 🔍 Analysis

<!-- 
  ANALYSIS:
  Synthesize your findings.
  Compare options, identify trade-offs, and highlight key insights.
-->

**Key Insights:**

- **OAuth 2.0:** Best for social login and reduced password management. Higher complexity but better UX.
- **JWT:** Best for API-first and SPA applications. Stateless design but requires token management.
- **Session-Based:** Best for traditional web apps. Simplest implementation but requires server-side storage.

**Trade-offs:**

- **Security:** All methods are secure when properly implemented. OAuth and JWT require more careful token handling.
- **User Experience:** OAuth provides best UX (social login). JWT and sessions are similar for traditional flows.
- **Complexity:** Sessions are simplest. OAuth and JWT require more setup and management.

**Recommendation:** For our use case, [Recommended Method] because [Reason].

---

## 💡 Recommendations

<!-- 
  RECOMMENDATIONS:
  Provide actionable recommendations based on your research.
  These will inform the decision phase.
-->

- [ ] Recommendation 1: Use [Method] for [Use Case] because [Reason]
- [ ] Recommendation 2: Implement [Security Feature] to ensure [Security Goal]
- [ ] Recommendation 3: Consider [Alternative] if [Condition] applies
- [ ] Recommendation 4: Plan for [Future Consideration] to support [Future Need]

---

## 📋 Requirements Discovered

<!-- 
  REQUIREMENTS:
  Extract requirements discovered during research.
  These will be documented in requirements.md file.
  Use FR-N, NFR-N, C-N, A-N format.
-->

**Functional Requirements:**
- FR-1: System must support user authentication
- FR-2: System must support [Specific Feature]
- FR-3: System must handle [Specific Feature]

**Non-Functional Requirements:**
- NFR-1: Authentication must be secure (meet [Security Standard])
- NFR-2: Authentication must provide good user experience (< [Time] seconds)
- NFR-3: Authentication must be maintainable

**Constraints:**
- C-1: Must work with existing [Tech Stack]
- C-2: Must support [Specific Requirement]
- C-3: Must comply with [Regulation/Standard]

**Assumptions:**
- A-1: Users have [Assumption]
- A-2: System will have [Assumption]
- A-3: [External Dependency] will be available

---

## 🚀 Next Steps

<!-- 
  NEXT STEPS:
  Document what should happen next.
  Typically, this leads to the decision phase.
-->

1. Review findings and recommendations
2. Use `/decision user-authentication --from-research` to make decisions
3. Document decisions in ADR format
4. Use `/transition-plan --from-adr` to transition to feature planning

---

## 📝 Notes

<!-- 
  ADDITIONAL NOTES:
  Include any additional context, constraints, or information.
  This can include implementation details, edge cases, or other relevant information.
-->

**Implementation Considerations:**
- [Tech Stack] supports all three methods
- [Library] provides good OAuth support
- [Framework] has built-in session management
- JWT requires additional library

**Edge Cases:**
- Token expiration handling
- Refresh token rotation
- Multi-device support
- Password reset flow

**Related Research:**
- [Link to related research documents]
- [Link to security research]
- [Link to UX research]

---

**Last Updated:** [Date]


# Open Library API Decisions

This document records the architectural decisions made while integrating the Open Library API into Readly.

---

# APIs Used

Readly currently uses three Open Library endpoints.

## 1. Search Endpoint

GET /search.json

Purpose:
- Search books by user query.
- Display lightweight search results.
- Allow the user to choose a book.

Only lightweight information is fetched here to keep search fast.

Current fields:

- work key
- edition key
- title
- author
- cover id
- median number of pages

---

## 2. Work Endpoint

GET /works/{workKey}.json

Purpose:

Retrieve information that belongs to the literary work itself.

Examples:

- description
- subjects
- work metadata

This information is generally shared by every edition.

---

## 3. Edition Endpoint

GET /books/{editionKey}.json

Purpose:

Retrieve edition-specific information.

Examples:

- publisher
- language
- translated title
- publish date
- edition metadata

Different editions of the same work may contain different values.

---

# Why multiple endpoints?

The Search endpoint intentionally returns lightweight information to make searching fast.

Important fields such as:

- publisher
- language
- description

are often unavailable or incomplete.

To build a richer book page, Readly combines data from multiple endpoints.

The flow is:

Search
        ↓
User selects a book
        ↓
Fetch Work
        ↓
Fetch Edition
        ↓
Merge responses
        ↓
Display a complete book

---

# Data Ownership

The source of each field is intentionally separated.

Search endpoint

- workKey
- editionKey
- title
- author
- coverId
- numberOfPagesMedian

Work endpoint

- description
- subjects

Edition endpoint

- publisher
- language
- translated title
- edition metadata

This separation makes the architecture easier to maintain and prevents unnecessary network traffic during search.

---

# Number of Pages Strategy

The exact number of pages is critical for Readly because reading progress depends on it.

Priority order:

1. number_of_pages from Edition
2. number_of_pages_median from Search
3. Manual user input (future feature)

This guarantees that every saved book has a usable page count whenever possible.

---

# Known Limitations

## Search language support

Open Library performs best with English queries.

Searching in Arabic may return incomplete or unrelated results even when Arabic editions exist.

This is a limitation of the Open Library search index rather than the Readly application.

The application will continue using Open Library because it provides:

- Work API
- Edition API
- rich metadata
- no authentication requirements
- free public access

The multilingual search limitation is accepted for version 1 of Readly.

---

# Future Improvements

Possible future enhancements include:

- Automatic language preference based on the user's locale.
- ISBN-based lookup for improved accuracy.
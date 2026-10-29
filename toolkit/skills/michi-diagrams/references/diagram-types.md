# Diagram types — syntax reference and traps

Read only the section for the type you chose. `visual-grammar.md` has a full
worked example of each.

## flowchart

```
flowchart LR            %% TB | TD | BT | LR | RL
    id[label]           %% rectangle
    id[(label)]         %% cylinder
    id{label}           %% diamond
    id([label])         %% stadium
    id[[label]]         %% subroutine
    a --> b             %% solid
    a -.-> b            %% dotted
    a ==> b             %% thick
    a -->|text| b       %% labelled
    subgraph gid["Title"]
        direction TB
        ...
    end
    classDef name fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    class a,b name      %% or  a:::name
```

Traps: quote labels with punctuation; `end` is reserved; subgraph direction is
ignored when a node inside links outside; do not link to a subgraph and to a
node inside it. Prefer `LR` for pipelines and `TB` for branching processes;
switch when crossings persist.

## sequenceDiagram

```
sequenceDiagram
    autonumber
    actor User
    participant App
    participant DB as "Database"
    User->>App: request          %% solid, arrowhead
    App-->>User: response        %% dotted, arrowhead
    App->>+DB: query             %% + activates
    DB-->>-App: rows             %% - deactivates
    alt condition
        ...
    else other
        ...
    end
    loop label
        ...
    end
    opt label ... end
    par label ... and ... end
    Note over App,DB: text
```

Traps: `;` in message text is a separator; declare participants in order;
never deactivate in both `alt` branches; `end` as the last word of a note
breaks; apostrophes in aliases break. No `classDef` here — grouping is via
`box "Title" ... end`, and box fills should be pastel with the same dark-mode
care.

## stateDiagram-v2

```
stateDiagram-v2
    direction LR
    [*] --> Draft
    Draft --> Review: submit
    state Review {
        direction TB
        [*] --> Technical
        Technical --> Ready: approved
        Ready --> [*]
    }
    Review --> Live: release
    state "Long name<br>second line" as Long
    state choice <<choice>>
    state fork <<fork>>
    Live --> [*]
```

Traps: always `-v2`; composite nesting beyond two levels is unreadable; a
composite needs its closing `}`; concurrent regions (`--`) beyond two get
cramped. `classDef` works on states (`Name:::class`).

## erDiagram

```
erDiagram
    A ||--o{ B : label        %% exactly one — zero or more
    A ||--|{ B : label        %% exactly one — one or more
    A }o--o{ B : label        %% many — many (use a join entity instead)
    A ||..o{ B : label        %% dotted = non-identifying
    A {
        string id PK
        string b_id FK
        string name
    }
```

Cardinality marks, left end first: `|o` zero-or-one, `||` exactly one,
`}o` zero-or-more, `}|` one-or-more. Traps: relationship labels do not take
`<br>` reliably; no `classDef`; capitalise entity names; declare the
most-connected entity first.

## gantt

```
gantt
    title Plan
    dateFormat YYYY-MM-DD
    axisFormat %d %b
    todayMarker off
    excludes weekends
    section Name
    Task        :done, id1, 2026-11-02, 2d
    Task        :active, id2, after id1, 3d
    Task        :crit, id3, after id1 id2, 1d
    Milestone   :milestone, id4, after id3, 0d
```

`dateFormat` is required. `after a b` waits for both. Status words (`done`,
`active`, `crit`) combine. `crit` is annotation, not computed.

## mindmap

```
mindmap
  root((Centre))
    a[square]
      child
    b{{hexagon}}
    c)cloud(
    d((circle))
    e(rounded)
```

Indentation is the structure; mixed tabs and spaces break it. One root only.
`)text(` is a cloud; `))text((` is a bang — easy to confuse. `<` renders as
`&lt;`; use words. No `classDef` worth relying on across renderers.

## classDiagram

```
classDiagram
    class Animal {
        +String name
        +makeSound() void
    }
    Dog --|> Animal : inherits
    Owner "1" --> "*" Dog : owns
    Car *-- Engine          %% composition
    Team o-- Member         %% aggregation
    A ..> B                 %% dependency
```

Traps: no line breaks in members; relationships and notes go outside
`namespace` blocks; generics are `List~T~`. Limited `classDef`; use only
when the source is object-oriented — a flowchart usually serves a design doc
better.

## timeline

```
timeline
    title History
    section Early
        2019 : event
        2020 : event : another event
    section Later
        2024 : event
```

Chronological, no dependencies. Use `gantt` if durations or dependencies
matter.

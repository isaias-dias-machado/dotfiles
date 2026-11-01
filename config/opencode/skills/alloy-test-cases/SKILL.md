---
name: alloy-scenarios
description: Generate small, distinct positive and negative Alloy scenarios from model declarations, a natural language requirement, and separate requested scenario counts. Use for concrete run commands with complete instance valuations and expect annotations, without formalizing the requirement.
---

# Alloy scenarios from requirements

Generate concrete Alloy scenarios, each a fully specified instance, for validating a formal specification against a natural language requirement. This skill adapts the few-shot prompt in `prompt_few.txt`; it works independently of that file and repository.

## Inputs and output

Accept Alloy declarations pasted directly into the request or supplied in a readable file, one natural language requirement, and separate nonnegative integer counts for positive and negative scenarios. An existing model file in the working directory is not required. When declarations are pasted, use that code directly; do not ask the user to create or locate a `.als` file just to generate scenarios. Respect any supplied background requirements and size limits. Ask only for missing inputs or ambiguities that would change a scenario's classification. Do not assume the two counts are equal.

When requesting missing inputs, use a short, ordinary sentence, without a numbered checklist, code fences, or Alloy comment markers. If the skill is invoked without any inputs, say: "Please paste your Alloy declarations and natural language requirement, and tell me how many positive and negative scenarios you want." If some inputs are already supplied, ask only for what is missing. Inputs may be given in plain text, together or across messages; do not require a special format. Clarification messages are not scenario output and are exempt from the code-only rule below.

Output exactly the requested counts as named `run` commands: `PositiveScenario1`, `PositiveScenario2`, ... with `expect 1`, then `NegativeScenario1`, `NegativeScenario2`, ... with `expect 0`. Avoid names already used in the model. Each command must have an Alloy comment explaining the concrete reason for its classification. When delivering generated scenarios, return only Alloy code, without Markdown fences or prose outside comments. Output commands to append to the supplied model; reproduce declarations only if the user requests a standalone model. If asked to save a file, follow the requested location and format.

Do not produce a fact, predicate, assertion, or check command that formalizes the requirement. Do not encode the requirement or its negation in the run body. The body must specify the concrete instance.

`expect` records an expected result; it does not impose a constraint. Every positive **and negative** scenario must be satisfiable under the declarations, module constraints, and supplied background facts. With a correct formalization of the target requirement enforced as a fact, positive scenarios remain satisfiable and negative scenarios become unsatisfiable. With declarations alone, negative scenarios are expected to be satisfiable too. Include a short Alloy comment explaining this distinction when the target requirement is not already enforced.

If no scenarios are requested, output `// No scenarios requested.` If the requested collection cannot exist (for example, declarations already imply the requirement so there are no valid negative scenarios), explain the obstacle in Alloy comments. Do not label a structurally invalid instance as a negative scenario or fill a shortfall with duplicates. Do not silently edit or remove supplied facts to make scenarios possible.

## Construct the scenarios

Read the declarations before choosing examples. Identify all domain signatures, signature multiplicities, subset and extension relationships, fields and their full arities, field multiplicities, ordering imports and aliases, and background constraints. A field's full arity includes its owning signature: `owns: Car -> lone Value` declared in `Person` is ternary. An omitted field multiplicity is `one`, not `set`.

Choose a small collection of scenarios that covers different ways of satisfying or violating the requirement. Prefer few atoms and tuples, but allow a slightly larger instance when it adds meaningful coverage. Include relevant boundary cases such as empty populations, singleton populations, sharing, disconnected components, or cycles. A universal requirement can hold vacuously in an empty population; an existential requirement generally cannot. Explain vacuity when it is the reason a scenario is positive.

Make every scenario structurally different from every other scenario, including across the two classes. Renaming atoms, reordering tuples, or changing a command name does not create a new instance. Compare cardinalities, subset memberships, relation shapes, and order positions up to consistent atom renaming. Prefer differences that exercise the requirement; do not rely only on arbitrary changes to irrelevant fields.

For each command:

- Bind atoms for each nonempty top-level domain signature with `some disj`, using fresh variable names. For example, `some disj p1, p2: Person | some disj c1, c2: Car { ... }`. Do not existentially quantify an atom from an empty signature. Use existing named singleton or enum atoms directly when appropriate.
- Give **every declared domain signature** an explicit equality to its entire set of atoms, including empty signatures, abstract parents, extensions, and `in` subsets. For example, `Person = p1 + p2`, `Adult = p1`, and `SUV = none`. Bind parent atoms once and express subsets using those same atoms. `in` subsets may overlap; sibling `extends` signatures must be disjoint; an abstract parent's atoms must be covered by its extensions.
- Give **every declared domain field** an explicit equality to its entire tuple set. Use unions of tuples such as `owns = p1->c1 + p2->c2`. For ternary fields use triples, such as `owns = p1->c1->v1`. Do not leave irrelevant values unconstrained: choose a simple legal value consistent with the declarations and background facts.
- For empty values use `S = none` for unary sets, `r = none->none` for binary relations, and `r = none->none->none` for ternary relations; continue this pattern for higher arities. Emptiness must respect field and signature multiplicities.
- Resolve overloaded field names with domain restriction, such as `Person <: link = ...` and `Car <: link = ...`. Use module qualification too when required by imports.
- State the scope of every top-level domain signature that accepts an explicit scope, including zero scopes. Prefer `for exactly 2 Person, exactly 1 Car`. The scopes and equalities must agree. Define descendant signatures with equalities rather than separate scopes. Respect implicit scopes for singleton and enum signatures. Do not assign domain scopes to built-in `Int`, `String`, or private library signatures; choose an adequate integer bitwidth when the model uses integers.

These equalities fix a complete valuation up to atom renaming; cardinality constraints, inclusions, and existential witnesses alone do not specify a scenario.

## Ordering and other model features

For each `open util/ordering[S]`, specify the complete binary successor relation as an explicit equality, using `S <: next` to disambiguate multiple orders. For an aliased import such as `open util/ordering[Value] as valueOrder`, use `Value <: valueOrder/next` if necessary. A valid order is a single chain covering all atoms, without cycles, branches, or skipped atoms.

An ordered signature must be nonempty. With one ordered atom, explicitly write `S <: next = none->none`. With two or more atoms, write the adjacent pairs, such as `S <: next = s1->s2 + s2->s3`. Ordering makes the signature's scope exact, so its atom count must match. Do not enumerate private implementation signatures from `util/ordering` or constrain computed helper functions as though they were independent fields.

Use literal integer values for integer fields, respecting bitwidth and arithmetic semantics. Inspect supplied modules when their declarations or facts affect the scenario. This workflow targets static instances; if mutable declarations or a temporal requirement require a trace, clarify the trace and scenario format before generating static scenarios.

Read [references/examples.md](references/examples.md) when a concrete template would help, especially for empty cases, subsets, higher arities, ordering, or overloaded fields. Adapt the examples to the actual requirement and counts.

## Check before delivery

Check the counts, names, complete signature and field valuations, tuple arities, scopes, multiplicities, background constraints, and structural diversity. Evaluate the natural language requirement on each fixed instance and make sure its comment identifies a real witness or violation.

If a local Alloy Analyzer is available, parse the model with the generated commands and check that every scenario is satisfiable against the declarations and background constraints before enforcing the target requirement. If the target is already an active fact, parsing is still useful, but its negative scenarios will be unsatisfiable; do not claim that this proves their structural validity. An existing, separately supplied oracle may be used to check the expected results in a temporary model. Do not invent a formalization of the target requirement for validation or include an oracle in the delivered scenarios. Do not change the source model for validation.

try `alloy lsp` cli command

Distinguish solver validation from manual reasoning. If no Analyzer or supplied oracle is available, add a brief Alloy comment stating which validation was not performed. Never claim executed or semantically verified scenarios without the corresponding check.

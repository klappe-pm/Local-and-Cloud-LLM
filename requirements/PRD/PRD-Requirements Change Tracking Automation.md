---
dateCreated: 2025-09-21
dateRevised: 2025-09-21
---

# PRD-Requirements Change Tracking Automation
### LLM Implementation File
This is the file where this requirement is documented for use with the LLM.
- Documentation is a set of instructions that added to a CLAUDE.md, README.md, or similar instruction and/or prioritization file

### Objective
Design, code, and implement a **`git` action-triggered script** to automatically compare the local and remote versions of the project's requirements file (`Open Requirements.md`) and generate a comprehensive, structured `Requirements Changelog.md` report based on the identified changes.

---
### 1. Automation and Execution Logic

**Trigger Mechanism:**
The solution must execute automatically upon a **`git` repository action** (e.g., pre-commit, pre-push, or a dedicated CI/CD workflow step) that precedes or is part of pushing local changes to the remote repository.

**Repository and File Locations:**

| **Type** | **Name/Description** | **URL/Path** |
| :--- | :--- | :--- |
| **GitHub Repository** | Source code and remote file storage. | `https://github.com/klappe-pm/Local-and-Cloud-LLM` |
| **Input File (Local)** | The local, staged version of the requirements file. | Path is implicitly handled by the `git` action. |
| **Input File (Remote)** | The previous, authoritative version of the requirements. | `Open Requirements.md` (or similar) within the GitHub repository. |
| **Output File (Local)** | The generated or updated changelog report. | `/Users/kevinlappe/Obsidian/Local and Cloud LLM/z-gitignore/requirements/Requirements Changelog.md` |
| **Output File (Repo)** | The final file to be committed and pushed. | `https://github.com/klappe-pm/Local-and-Cloud-LLM/blob/main/Requirements%20Changelog.md` |

**Comparison Logic:**
1.  **Retrieve Remote:** Fetch the **most recent version** of `Open Requirements.md` from the GitHub repository (the Source of Truth).
2.  **Retrieve Local:** Access the **local, staged version** of `Open Requirements.md` slated for the current commit.
3.  **Perform Differential Analysis:** Parse and compare the two files to identify all changes in content, status, and metadata for each requirement.

**Commit Management:**
The script must **save the generated/updated output file (`Requirements Changelog.md`) locally** and automatically stage and commit these changes to the repository as part of the triggering `git` action.

---
### 2. Input File Specification (`Open Requirements.md`)

The input file is a **Markdown file** containing a list of all project requirements, formatted as a **Markdown Table**.

**Data Structure (Table Columns):**
The table must contain columns for the following metadata, which must be parsable for every requirement row:

| **Metadata Field** | **Description** | **Data Format/Values** |
| :--- | :--- | :--- |
| **Status Checkbox** | Indicates the requirement's state. | **Open:** `- [ ]` or **Closed:** `- [x]` |
| **nameRequirement** | The requirement's name or description. | String |
| **dateCreated** | Initial date the requirement was added. | `yyyy-MM-dd` |
| **dateRevised** | Date the requirement's content was last modified. | `yyyy-MM-dd` |
| **dateClosed** | Date the requirement was marked closed (`- [x]`). | `yyyy-MM-dd` (Must be populated only upon closure) |
| **category** | Primary functional area. | String |
| **subCategory** | Secondary functional area. | String |
| **topics** | List of relevant keywords or tags. | String/List |
| **subTopics** | List of granular keywords or tags. | String/List |
| **priority** | The requirement's relative importance. | `P0` (Highest), `P1`, `P2`, `P3` |
| **Change Summary** | A summary of the change in the current commit. | **New**, **Deleted**, **Revised**, or a **1-2 line description of completion** |

**Status and Change Identification Rules:**
1.  **State Identification:** The requirement's status is derived from the markdown checkbox (`- [ ]` for Open, `- [x]` for Closed).
2.  **Human Deletion Rule:** If a requirement row is present in the remote file but *absent* in the local file, it must be logged as **Deleted**. The user will **not** use a checkbox to close a requirement before deleting it.
3.  **Change Summary Rule:** The script must determine the appropriate value for the `Change Summary` column based on the comparison:
    * **New:** Requirement exists in the local file but not the remote.
    * **Deleted:** Requirement exists in the remote file but not the local.
    * **Revised:** The requirement's name/description or any metadata (excluding `dateClosed`) has changed.
    * **Completion:** The status checkbox changed from `- [ ]` to `- [x]`. The user must manually input the **1-2 line description of what was completed** into this column as part of the commit.

---
### 3. Output File Generation (`Requirements Changelog.md`)

The script must **create or append** to the `Requirements Changelog.md` file, starting at the first row after any existing headers or formatting, using the specified structure.

#### 3.1 Changelog Entry Structure

The overall structure of the `Requirements Changelog.md` file must be:

1.  **Changelog Header:** The file must start with the H1 header `# Requirements Changelog`.
2.  **Commit Log:** A new H2 header must be added for the current commit: `## [yyyy-MM-dd]-[commit number]`.
3.  **Summary:** A summary of the changes in the current commit should be added under the H2 header.
4.  **Report Sections:** The following H2 sections must be generated or updated:

#### 3.2 Report Sections

##### Open Requirements
* **Header:** `## Open Requirements`
* **Content:** An alphabetically sorted list of all requirements currently marked as **open** (`- [ ]`) in the local, new version of the input file.
* **Format:** Each item must display its **full metadata**.

##### New Closed Requirements
* **Header:** `## New Closed Requirements`
* **Content:** A list of all requirements that were changed from **open** in the remote version to **closed/complete** (`- [x]`) in the local version.

##### Aged Requirements
* **Header:** `## Aged Requirements`
* **Purpose:** Categorize **all open requirements** by their age (`Today's Date` - `dateCreated`).
* **Sorting:** The H3 sections must be sorted **from oldest to newest** within the report.
* **Categories (H3 Headers):**

| **Header** | **Age Range** |
| :--- | :--- |
| `### >120 days (121 or more days)` | 121+ days |
| `### 120 days (91 to 120 days)` | 91 - 120 days |
| `### 90 days (61 to 90 days)` | 61 - 90 days |
| `### 60 days (31 to 60 days)` | 31 - 60 days |
| `### 30 days (0 to 30 days)` | 0 - 30 days |

##### All Closed Requirements
* **Header:** `## All Closed Requirements`
* **Content:** A complete, cumulative list of every requirement ever marked as closed.
* **Organization:** This section must be organized using **H3 headers** based on the `dateClosed`.
* **H3 Header Format:** `yyyy-MM-dd`.
* **Sorting:** H3 headers must be sorted in **reverse chronological order** (newest date first). Requirements closed on the same date should be listed alphabetically under their respective date header.

Write file to : /Users/kevinlappe/Obsidian/Local and Cloud LLM/z-gitignore/local-repo-on-commit-requirements.md file
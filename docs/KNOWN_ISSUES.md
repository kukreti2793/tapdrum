# Known issues and open questions

All items are open unless explicitly resolved below. Planning gaps are not
confirmed application defects; there is no application yet.

| ID | Kind | Issue / next action |
| --- | --- | --- |
| K-01 | Research risk | Monocular contact/hover separation unproven; run controlled S1 only after M1 and approval |
| K-02 | Performance risk | Camera transport and reversal confirmation may exceed latency goals; measure rather than promise |
| K-03 | Hardware prerequisite | Logic/iOS/Xcode versions and original cable now owner-reported; mount/angle, installed active SDK and actual capture/Logic operation still unverified |
| K-04 | Environment limitation | Cloud is Linux without Apple SDKs/Logic/cameras; native compatibility and hardware validation require Mac |
| K-05 | Research access | Initial Apple block resolved in subsequent requests; official Google guide still blocked. Apple APIs and MediaPipe primary source reviewed; draft settings saved, publication not performed |
| K-06 | Privacy/measurement constraint | Camera-only/no-recordings chosen. Precise event truth and contact→audible latency lack an approved independent measurement method; do not claim them verified |
| K-07 | Tracking risk | Occluded tips, coupled fingers, palm proxy and hand-ID swaps unresolved; score all contacts separately |
| K-08 | Architecture gate | Swift/Vision/CoreMIDI recommendation, numeric gates and deployment target not finalized/approved; no M1 authorization |
| K-09 | Integration risk | MIDI collisions, cleanup, Logic routing, instrument mapping and host lifecycle untested |
| K-10 | Dependency risk | MediaPipe native macOS packaging/acceleration, exact model size/license and resource cost unverified; not installed |
| K-11 | Future scope | AUv2/AUv3 choice, sampler, signing/notarization and supported release matrix deferred until later milestones |
| K-12 | Resolved Git delivery issue | Initial REST read failed; authenticated branch push and draft PR #1 creation/read subsequently succeeded. No credential request, merge or force push |

Resolved initial setup assumption: the repository is no longer remotely empty;
the owner's README commit was fetched before creating this documentation branch.
Apple documentation access and GitHub PR delivery were also subsequently verified;
the earlier access failures do not remain blockers for those completed operations.

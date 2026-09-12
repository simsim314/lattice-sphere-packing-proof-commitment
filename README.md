# lattice-sphere-packing-proof-commitment

Public timestamp and SHA-256 commitment for candidate proofs of improved lattice sphere-packing lower bounds, including the full $\kappa=1$ logarithmic gain.

**Author / originator:** Michael Simkin  
**Initial public commitment:** September 11, 2026

This repository records public cryptographic commitments to mathematical work concerning lower bounds for lattice sphere packing.

The source manuscripts themselves are kept private/local. For each committed source file, the repository publishes:

- a `.sha256` file containing its SHA-256 digest;
- an `.ots` OpenTimestamps proof.

These artifacts allow the exact source file to be revealed later and cryptographically checked against the earlier public commitment.

## Mathematical claim

The work concerns the progression

```math
\kappa=\frac{1}{1+e},
```

then constructions approaching

```math
\kappa=1-\varepsilon,
```

and finally a candidate full $\kappa=1$ construction yielding

```math
\Delta_d^L \ge c\,d^2\log\log d\,2^{-d}.
```

More precisely, for a positive integer $d$, let $\Delta_d^L$ denote the maximum density of a lattice sphere packing in $d$-dimensional Euclidean space.

The claimed theorem is:

> There exist universal constants $c>0$ and $d_0$ such that, for every integer $d\ge d_0$,
>
> ```math
> \Delta_d^L \ge c\,d^2\log\log d\,2^{-d}.
> ```

This is the full logarithmic gain, corresponding to $\kappa=1$ in the notation

```math
(\log\log d)^\kappa.
```

## Cryptographic commitments

### Appendices A and B

- [SHA-256 commitment](files/Appendices_A_B.tex.sha256)
- [OpenTimestamps proof](files/Appendices_A_B.tex.ots)

### Main lattice sphere-packing preprint

- [SHA-256 commitment](files/Simkin_Lattice_Sphere_Packing_Preprint.tex.sha256)
- [OpenTimestamps proof](files/Simkin_Lattice_Sphere_Packing_Preprint.tex.ots)

### Simplified $\kappa=1$ divisor-star construction

- [SHA-256 commitment](files/simplified_kappa_1_divisor_star.tex.sha256)
- [OpenTimestamps proof](files/simplified_kappa_1_divisor_star.tex.ots)

## Verification

If the corresponding original source file is available locally, its SHA-256 commitment can be checked with:

```bash
sha256sum -c FILE.tex.sha256
```

An OpenTimestamps proof can be updated and verified with:

```bash
ots upgrade FILE.tex.ots
ots verify FILE.tex.ots
```

The `.ots` proof commits to the exact contents of the corresponding source file. OpenTimestamps calendar servers aggregate commitments and anchor them into the Bitcoin blockchain.

The manuscript and appendices may subsequently be modified, reviewed, or developed collaboratively. Later versions can therefore differ from the exact versions represented by these commitment files.

The purpose of this repository is to preserve public, independently verifiable evidence that the corresponding exact file contents existed no later than the timestamps established by these commitments.

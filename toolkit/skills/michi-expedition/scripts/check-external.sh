#!/usr/bin/env bash
# Report what a reader outside the organization shouldn't see in a document.
#
#   scripts/check-external.sh <markdown-file>...
#
# One line per finding, "<repo-relative file>:<line>: <kind> "<text>"", for three kinds:
#   first person     I, me, my, we, us, our (and their contractions); "you" is ordinary documentation voice
#   internal id      M<n>, S<n>, §<n> (milestone, session, and section numbers)
#   repo path        a path written in the text that git tracks in the repo, or a folder of one (not one
#                    starting ./ or ../; untracked files such as node_modules are anyone's)
# Fenced code blocks are skipped. Link targets are ignored; link text is checked. First person is not
# looked for inside inline code; ids and paths are. Exits 1 when there are findings, 0 when there are none,
# and 2 when the check itself can't run (a missing file, no repo, no perl).
# The build runs this for external editions (see "Editions" in references/project-templates.md).
set -uo pipefail

[[ $# -gt 0 ]] || { echo "usage: $0 <markdown-file>..." >&2; exit 2; }

found=0
for file in "$@"; do
  [[ -f "$file" ]] || { echo "$0: no such file: $file" >&2; exit 2; }
  dir="$(cd "$(dirname "$file")" && pwd -P)" || exit 2
  repo_root="$(git -C "$dir" rev-parse --show-toplevel)" || exit 2
  rel="$dir/$(basename "$file")"
  rel="${rel#"$repo_root"/}"
  tracked="$(mktemp)" || exit 2
  git -C "$repo_root" -c core.quotePath=off ls-files >"$tracked" || { rm -f "$tracked"; exit 2; }
  TRACKED="$tracked" REL="$rel" perl -ne '
    BEGIN {
      $fence = 0; $found = 0;
      open(my $list, "<", $ENV{TRACKED}) or exit 2;
      while (my $line = <$list>) {
        chomp $line;
        $tracked{$line} = 1;
        $tracked{$1} = 1 while $line =~ s{/[^/]*$}{} && $line =~ /^(.+)$/;
      }
      close $list;
    }
    if (/^\s*(```|~~~)/) { $fence = !$fence; next }
    next if $fence;
    my $text = $_;
    $text =~ s/\]\([^)]*\)/]/g;          # link targets
    $text =~ s/<?https?:\/\/\S+>?//g;      # bare URLs
    my $prose = $text;
    $prose =~ s/`[^`]*`//g;                # inline code
    (my $plain = $text) =~ s/`//g;
    my @findings;
    while ($prose =~ /(?<![\w\x27\/-])(I|I\x27m|I\x27ve|I\x27d|I\x27ll|[Mm]e|[Mm]y|[Ww]e|[Ww]e\x27re|[Ww]e\x27ve|[Ww]e\x27d|[Ww]e\x27ll|[Oo]ur|[Oo]urs|[Uu]s)(?![\w\x27\/-])/g) {
      push @findings, "first person \"$1\"";
    }
    while ($plain =~ /(?<![\w-])(M\d+|S\d+|§\s*[\d.]+[a-z]?)(?![\w-])/g) {
      push @findings, "internal id \"$1\"";
    }
    while ($plain =~ /(?<![\w\/.-])([\w.-]+(?:\/[\w.-]+)+)/g) {
      (my $path = $1) =~ s/[.,:;]+$//;
      next if $path =~ /^\.\.?\//;           # relative to somewhere else, such as the reader`s own project
      (my $key = $path) =~ s{/$}{};
      push @findings, "repo path \"$path\"" if $tracked{$key};
    }
    for my $finding (@findings) { print "$ENV{REL}:$.: $finding\n"; $found = 1 }
    END { exit($found ? 1 : 0) }
  ' "$file"
  status=$?
  rm -f "$tracked"
  case "$status" in
    0) ;;
    1) found=1 ;;
    *) exit 2 ;;
  esac
done
exit "$found"

#!/usr/bin/env bash

set -euo pipefail

origin=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || exit

github_user="opatry"
resume_gist_id="0ae5c49d91a60f9351044fb8ae852095"
resume_file="resume.json"

json_resume_cache="${origin}/json_resume_cache.json"

force_fetch=${1:-false}

if ${force_fetch} || [ ! -f "${json_resume_cache}" ]; then
  gist_url="https://gist.githubusercontent.com/${github_user}/${resume_gist_id}/raw/${resume_file}"
  curl -s "${gist_url}" > "${json_resume_cache}"
fi

# TODO illustration/icons per project/company

format_date() {
  local date=${1:-"present"}

  if [ "${date}" = "present" ]; then
    echo "${date}"
  else
    gdate -d "${date}" +"%B %Y"
  fi
}

format_social_profile() {
  local network="${1}"
  local username="${2}"
  local url="${3}"

  case "${network,,}" in
    twitter) icon_class="twitter";;
    linkedin) icon_class="linkedin";;
    github) icon_class="github";;
    mastodon) icon_class="mastodon";;
    *) icon_class="${network,,}";;
  esac

  echo "[<span class=\"icon-${icon_class}\" title=\"${username} on ${network}\"></span>](${url})"
}

format_social_profiles() {
  local profiles="${1}"

  echo '<div class="special-links" style="text-align: center; margin-top: 30px;" markdown="1">'
  jq -c '.[]' <<< "${profiles}" | while IFS=$'\n' read -r profile; do
    format_social_profile \
      "$(jq -r '.network' <<< "${profile}")" \
      "$(jq -r '.username' <<< "${profile}")" \
      "$(jq -r '.url' <<< "${profile}")"
  done
  cat << __END
[<span class="icon-rss2"></span>](<%= @items['/rss.*'].path %>)
</div>
__END
}

format_experience() {
  local company="${1}"
  local position="${2}"
  local website="${3}"
  local start_date
  start_date="$(format_date "${4}")"
  local end_date
  end_date="$(format_date "${5:-"present"}")"
  local summary="${6}"

  cat << __END

#### ${position} @[${company}](${website})

${start_date} — ${end_date}
{: .metadata}

${summary}
__END
}

format_experiences() {
  local experiences="${1}"

  jq -c '.[]' <<< "${experiences}" | while IFS=$'\n' read -r experience; do
    # TODO fallback to "present" if no "endDate"
    format_experience \
      "$(jq -r '.company' <<< "${experience}")" \
      "$(jq -r '.position' <<< "${experience}")" \
      "$(jq -r '.website' <<< "${experience}")" \
      "$(jq -r '.startDate' <<< "${experience}")" \
      "$(jq -r '.endDate' <<< "${experience}")" \
      "$(jq -r '.summary' <<< "${experience}")"

    echo ""
    jq -r '.highlights[]' <<< "${experience}" | while IFS=$'\n' read -r highlight; do
      if [[ ${highlight} =~ http?(s)://* ]]; then
        echo " - [${highlight}](${highlight})"
      else
        echo " - ${highlight}"
      fi
    done
  done
}

format_project() {
  # either "full" or "card"
  local mode="${1}"
  local name="${2}"
  local url="${3}"
  local start_date
  start_date="$(format_date "${4}")"
  local end_date
  end_date="$(format_date "${5:-"present"}")"
  local description="${6}"

  case "${name,,}" in
    *nebo*)
      slug="nebo"
    ;;
    *calculator*)
      slug="calculator"
    ;;
    *stanza*)
      slug="stanza"
    ;;
    *tydom*)
      slug="tydom"
    ;;
    *taskfolio*)
      slug="taskfolio"
    ;;
    *)
      echo "Unsupported project, define a slug for it"
      exit 0
    ;;
  esac

  if [ "${mode}" = "full" ]; then
    cat << __END

${start_date} — ${end_date}
{: .metadata}

${description}

<%= project_card_illustration('${slug}') %>

[See project website for more…](${url})
{: .button}
__END
  elif [ "${mode}" = "card" ]; then
    echo "<%= project_card('${slug}', '${name}', '${start_date} — ${end_date}') %>"
  fi
}

format_project_cards() {
  local projects="${1}"

  echo '<div class="project-cards">'
  jq -c '.[]' <<< "${projects}" | while IFS=$'\n' read -r project; do
    # TODO fallback to "present" if no "endDate"
    format_project \
      "card" \
      "$(jq -r '.name' <<< "${project}")" \
      "$(jq -r '.url' <<< "${project}")" \
      "$(jq -r '.startDate' <<< "${project}")" \
      "$(jq -r '.endDate' <<< "${project}")" \
      "$(jq -r '.description' <<< "${project}")"
  done
  echo '</div>'
}

json_resume=$(cat "${json_resume_cache}")

name=$(jq -r '.basics.name' <<< "${json_resume}")
picture=$(jq -r '.basics.picture' <<< "${json_resume}")
label=$(jq -r '.basics.label' <<< "${json_resume}")
summary=$(jq -r '.basics.summary' <<< "${json_resume}")

social_profiles_md=$(format_social_profiles "$(jq .basics.profiles <<< "${json_resume}")")
experiences_md=$(format_experiences "$(jq .work <<< "${json_resume}")")
project_cards_md=$(format_project_cards "$(jq .projects <<< "${json_resume}")")

cat > "${origin}/../content/index.md" << __END
---
title: Home
layout: home
---

![](${picture})
{: .avatar}

# ${name}

${label}
{: .subtitle}

## Summary
${summary}

See my [resume](<%= @items['/resume.*'].path %>).
{: .metadata}

## Projects
${project_cards_md}

${social_profiles_md}
__END

cat > "${origin}/../content/projects.md" << __END
---
title: Projects
layout: page
---

${project_cards_md}
__END

cat > "${origin}/../content/resume.md" << __END
---
title: Resume
layout: page
---

# ${name}

${label}
{: .subtitle}

### Summary
${summary}

### Experience
${experiences_md}

See some [projects](<%= @items['/projects.*'].path %>) I worked on.
{: .metadata}
__END

mkdir -p "${origin}/../content/projects"

jq -c .projects[] <<< "${json_resume}" | while IFS=$'\n' read -r project; do
  project_name=$(jq -r '.name' <<< "${project}")

  # TODO fallback to "present" if no "endDate"
  page_content=$(format_project \
    "full" \
    "$(jq -r '.name' <<< "${project}")" \
    "$(jq -r '.url' <<< "${project}")" \
    "$(jq -r '.startDate' <<< "${project}")" \
    "$(jq -r '.endDate' <<< "${project}")" \
    "$(jq -r '.description' <<< "${project}")" \
  )

  case "${project_name,,}" in
    *nebo*)
      project_slug="nebo"
    ;;
    *calculator*)
      project_slug="calculator"
    ;;
    *stanza*)
      project_slug="stanza"
    ;;
    *tydom*)
      project_slug="tydom"
    ;;
    *taskfolio*)
      project_slug="taskfolio"
    ;;
    *)
      echo "Unsupported project, define a slug for it"
      exit 0
    ;;
  esac
  cat > "${origin}/../content/projects/${project_slug}.md" << __END
---
title: ${project_name}
layout: page
kind: page
---

${page_content}
__END
done
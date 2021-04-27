export function copyAndAlert(text) {
  const alert_message = "Copied to clipboard. Share it with the world :)";
  if (navigator && navigator.clipboard) {
    try {
      navigator.clipboard.writeText(text).then((_) => alert(alert_message));
    } catch (e) {
      console.error("Cannot copy", e);
    }
  } else {
    // Using old API
    const input = appendHiddenChildWith(text);
    input.select();
    input.setSelectionRange(0, 9999); // For mobile devices
    document.execCommand("copy");
    input.parentNode.removeChild(input);

    alert(alert_message);
  }
}

function appendHiddenChildWith(text) {
  const input = document.createElement("input");
  input.setAttribute("type", "hidden");
  input.setAttribute("id", "text_to_copy");
  input.setAttribute("value", text);
  document.body.appendChild(input);

  return input;
}

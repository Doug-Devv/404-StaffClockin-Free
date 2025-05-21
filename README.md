# Staff Clock-In Script

A lightweight and functional staff clock-in system with Discord webhook logging. This script records when staff members clock in and out, calculates their total time on duty, and sends it to a Discord webhook using an embed format.


IF ANY ISSUES OCCUR CONTACT ME ON DISCORD @LUA.DADDY OR JOIN THE SUPPORT DISCORD https://disocrd.gg/404solutions


---

## Features

- Discord Webhook Integration: Logs staff activity to a webhook.
- Time on Duty Tracking: Calculates and includes time on duty in the webhook embed.
- Simple Configuration: Easily customizable to fit your server's needs.
- Clean Embed Logs: All logs are formatted using Discord embeds for clear presentation.

---

## Installation

1. Download or clone the repository.
2. Open the configuration file and enter your details.
3. Add the script to your server.

---

## Configuration

Below is the default configuration (`Config`) that you can modify to suit your setup:

```lua
Config = {}

-- Your Discord webhook URL
Config.WebhookURL = "your.webhook.url"

-- Webhook avatar image
Config.WebhookAvatar = ""  -- Webhook profile image

-- Embed image (displays in the message body)
Config.EmbedImage = ""

-- Webhook username
Config.WebhookName = "404 Free Staff Clockin System"

-- Discord embed color (decimal format)
Config.EmbedColor = 3447003  -- Blue

-- Footer text
Config.FooterText = "Clockin Logs Made By 404 Solutions"

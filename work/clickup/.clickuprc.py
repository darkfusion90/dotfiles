import click
import os

def getlastpathfromurl(url):
    lastpartdirty = os.path.basename(url)
    lastpart = lastpartdirty.split("?")[0]
    return lastpart

def slugify(text):
    import re
    import unicodedata
    text = unicodedata.normalize('NFD', text).encode('ascii', 'ignore').decode('utf-8')
    text = re.sub('[^\w\s-]', '', text).strip().lower()
    text = re.sub('[-\s]+', '-', text)
    return text

@click.command()
@click.option('--clickup_url', prompt='Enter ClickUp URL', help='The ClickUp URL.')
@click.option('--clickup_ticket_title', prompt='Enter ClickUp ticket title', help='The ClickUp ticket title.')
def gcbrckp(clickup_url, clickup_ticket_title):
    """
    This function returns a git branch name with the given clickup_url, and clickup_ticket_title
    """
    clickup_ticket_title = clickup_ticket_title.lower()
    clickup_ticket_id = getlastpathfromurl(clickup_url)
    clickup_ticket_slug = slugify(clickup_ticket_title)

    result = f'gaurav.s/CU-{clickup_ticket_id}/{clickup_ticket_slug}'
    os.system('git checkout -b {}'.format(result))

gcbrckp()

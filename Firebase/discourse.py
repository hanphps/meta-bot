import os

import discord
from parser import parse,date

class discourser(discord.Client):
    def __init__(self,settings):
        self.settings = parse(settings)
    
    async def on_ready(self):
        print(f'{self.user} has connected to Discord!')
    
    async def create_channel(ctx, channel_name='Bot-Queue'):
        guild = ctx.guild
        existing_channel = discord.utils.get(guild.channels, name=channel_name)
        if not existing_channel:
            print(f'Creating a new channel: {channel_name}')
            await guild.create_text_channel(channel_name)

    def new_queue(self,data):
        user = data['Sender']
        time = data['Time']
        channel = discord.utils.get(guild.channels, name=channel_name)

    def go(self):
        self.run(self.settings["api-key"])


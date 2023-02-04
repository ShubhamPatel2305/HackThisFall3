import React, {useState, useContext, useEffect} from 'react'


import { ChatDAppContext } from '@/Context/ChatDAppContext'
 

const ChatDApp = () => {
    const {title}= useContext(ChatDAppContext);
  return (
    <div>{title }</div>
  )
}

export default ChatDApp
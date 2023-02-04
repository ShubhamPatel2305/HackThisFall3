import React, { useState, useEffect } from "react";
import { useRouter } from "next/router";

import {
    CheckIfWalletConnected,
    connectWallet,
    connectingWithContract,
  } from "../Utils/apiFeature";

  export const ChatDAppContext= React.createContext();

  export const ChatDAppProvider= ({children}) => {
      const title="Hola Senor"

    const [account, setAccount] = useState("");
    const [userName, setUserName] = useState("");
    const [friendLists, setFriendLists] = useState([]);
    const [friendMsg, setFriendMsg] = useState([]);
    const [loading, setLoading] = useState(false);
    const [userLists, setUserLists] = useState([]);
    const [error, setError] = useState("");

    const [currentUserName, setCurrentUserName] = useState("");
    const [currentUserAddress, setCurrentUserAddress] = useState("");

    const router = useRouter();

    const fetchData = async () => {
        try {
          const contract = await connectingWithContract();
          const connectAccount = await connectWallet();
          setAccount(connectAccount);
          const userName = await contract.getUsername(connectAccount);
          setUserName(userName);
          const friendLists = await contract.getMyFriendList();
          setFriendLists(friendLists);
          const userList = await contract.getAllAppUser();
          setUserLists(userList);
        } catch (error) {
          // setError("Please Install And Connect Your Wallet");
          console.log(error);
        }
      };
      useEffect(() => {
        fetchData();
      }, []);

      return(
          <ChatDAppContext.Provider value={{title}} >
              {children} 
          </ChatDAppContext.Provider>
      )
  } 
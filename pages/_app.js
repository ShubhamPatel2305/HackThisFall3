import '@/styles/globals.css'

import { ChatDAppProvider } from '@/Context/ChatDAppContext'
import { navbar } from '../Components/index'

export default function App({ Component, pageProps }) {
  <div>
    <ChatDAppProvider>
      <navbar />
      <Component {...pageProps} />
    </ChatDAppProvider>
  </div>
}

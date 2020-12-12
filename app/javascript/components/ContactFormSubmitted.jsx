import React from 'react'

const ContactFormSubmitted = (props) => (
  <React.Fragment>
    <div className="content is-size-6 has-text-centered">
      <p>Message sent! Thanks</p>
      <button className="button is-white has-text-link" onClick={()=> props.showContactForm()}>Return to contact form</button>
     </div>
  </React.Fragment>
)

export default ContactFormSubmitted
const chatbotToggler = document.querySelector(".chatbot-toggler");
const closeBtn = document.querySelector(".close-btn");
const chatbox = document.querySelector(".chatbox");
const chatInput = document.querySelector(".chat-input textarea");
const sendChatBtn = document.querySelector("#send-btn");
const inputInitHeight = chatInput.scrollHeight;
const entity = window.location.pathname.split('/').pop().replace("lista", "").replace(".php", "") ;
const warning = "Me desculpa,nao entendi...";
const pageTitle = document.querySelectorAll('title')[document.querySelectorAll('title').length  - 1];
let avatar = "brunetteHair"

const createChatLi = (message, className) => {
    const chatLi = document.createElement("li");
    chatLi.classList.add("chat", `${className}`);

    let chatContent = "<p></p>";

    chatLi.innerHTML = chatContent;

    if (message === "image"){
        chatLi.querySelector("p").innerHTML = "<div class='thinking-div'><img src='/static/img/typing.gif' class='thinking-image'></div>";
    } else {
        chatLi.querySelector("p").textContent = message;
    }
    return chatLi;
}

function callCustomerServiceApi (chatbox) {
    const urlApi = "http://192.168.0.59:8000/customer_service"
    const outgoing_lst = chatbox.querySelectorAll(".outgoing");
    const msg = outgoing_lst[outgoing_lst.length-1].innerText;
    const user = selChatCustomer.options[selChatCustomer.selectedIndex].text

    fetch(urlApi, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            question: msg,
            user: user
        }),
    })
    .then(response => response.json())
    .then(result => {
        incoming_lst = chatbox.querySelectorAll(".chat.incoming");
        last_bot_message = incoming_lst[incoming_lst.length-1].querySelector('p');
        last_bot_message.innerText = result['answer'].replace("Angel: ", "") 
    })
    .catch(error => {
        incoming_lst = chatbox.querySelectorAll(".chat.incoming");
        last_bot_message = incoming_lst[incoming_lst.length-1].querySelector('p');
        last_bot_message.innerText = warning
    });
}

selChatCustomer.addEventListener('change', function() {
    chatbox.innerHTML = ""
});

function callBiApi (chatbox) {
    const urlApi = "http://localhost:8000/business_inteligence";
    const outgoing_lst = chatbox.querySelectorAll(".outgoing");
    const last_user_msg = outgoing_lst[outgoing_lst.length-1].innerText;

    fetch(urlApi, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            question: last_user_msg,
            entity: entity
        }),
    })
    .then(response => response.json())
    .then(result => {
        incoming_lst = chatbox.querySelectorAll(".chat.incoming");
        last_bot_message = incoming_lst[incoming_lst.length-1].querySelector('p');
        last_bot_message.innerText = result['answer']
    })
    .catch(error => {
        incoming_lst = chatbox.querySelectorAll(".chat.incoming");
        last_bot_message = incoming_lst[incoming_lst.length-1].querySelector('p');
        last_bot_message.innerText = warning
    });
}

const handleChat = () => {
    userMessage = chatInput.value.trim();
    if (!userMessage) return;
    chatInput.value = "";
    chatInput.style.height = `${inputInitHeight}px`;
    chatInput.style.overflowY = 'hidden';

    chatbox.appendChild(createChatLi(userMessage, "outgoing"));
    chatbox.scrollTo(0, chatbox.scrollHeight);

    setTimeout(() => {
        const incomingChatLi = createChatLi("image", "incoming");
        chatbox.appendChild(incomingChatLi);
        chatbox.scrollTo(0, chatbox.scrollHeight);

        if (pageTitle.innerText == "Agendamento") {
            callCustomerServiceApi(chatbox);  
        } else {
            callBiApi (chatbox)  
        }

    }, 600);
}

chatInput.addEventListener("input", () => {
    chatInput.style.height = `${inputInitHeight}px`;
    chatInput.style.height = `${chatInput.scrollHeight}px`;
});

sendChatBtn.addEventListener("click", (e) => {
    e.preventDefault();
    handleChat();
});

chatInput.addEventListener("keydown", (e) => {
    if(e.key === "Enter" && !e.shiftKey && window.innerWidth > 800) {
        e.preventDefault();
        handleChat();
    }
});

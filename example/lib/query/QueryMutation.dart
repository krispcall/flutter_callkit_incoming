class QueryMutation {
  String mutationLogin() {
    return """
      mutation login(\$data:LoginInputData!)
      {
        login(data:\$data)
        {
          status,
          data
          {
            token,
            details 
            {
              id,
              workspaces
              {
                id,
                memberId,
                title,
                role,
                photo,
                status,
                plan 
                {
                 cardInfo,
                 remainingDays,
                }
              },
              userProfile
              {
                 status
                 profilePicture,
                 firstname,
                 lastname,
                 email,
                 defaultLanguage,
                 defaultWorkspace,
                 stayOnline,
              }
            }
            intercomIdentity
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String checkDuplicateLogin() {
    return """
      query checkDuplicateLogin(\$data:LoginInputData!)
      {
        checkDuplicateLogin(data:\$data)
        {
          status,
          data
          {
            success 
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationMemberLogin() {
    return """
      mutation memberLogin(\$data:MemberLoginInputData!) 
      {
        memberLogin(data: \$data)
        {
          status,
          data
          {
            accessToken,
            refreshToken,
          },
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String updateOnlineStatus() {
    return """
      mutation updateOnlineStatus(\$data: EditOnlineStatusInputData!) 
      {
        updateOnlineStatus(data: \$data)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id
            onlineStatus
          }
        }
      }
    """;
  }

  String cancelOutgoingCall() {
    return """
     mutation cancelOutgoingCall(\$data: OutgoingCancelInput!) 
     {
        cancelOutgoingCall(data: \$data)
        {
          status,
          data
          {
            CancelStatus     
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
     }
    """;
  }

  String rejectCall() {
    return """
     mutation rejectConversation(\$data: RejectConversationInput!) 
     {
        rejectConversation(data: \$data)
        {
          status
          data {
            success
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
     }
    """;
  }

  String queryVoiceToken() {
    return """
      query getVoiceToken(\$platform:Platform)
      {
        getVoiceToken(platform:\$platform)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            voiceToken
          }
        }
      }
    """;
  }

  String mutationCreateDeviceInfo() {
    return """
      mutation deviceRegister(\$data: DeviceRegisterInputData!) 
      {
        deviceRegister(data: \$data)
        {
          status,
          data
          {
            id,
            platform,
            fcmToken,
            version,
          },
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String queryWorkspaceDetail() {
    return """
      query workspace 
      {
        workspace
        {
          status
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id
            title
            notification
            photo
            memberId
            loginMemberRole
            {
              role
            }
            status
            plan 
            {
              cardInfo
              remainingDays
              subscriptionActive
              trialPeriod,
              currentCredit,
              planDetail
              {
                title,
                interval,
              }
            }
            review
            {
              review_status
              risk_score
            }
          }
        }
      }
    """;
  }

  String queryChannelList() {
    return """
      query channels 
      {
        channels
        {
          status
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id,
            countryLogo,
            country,
            countryCode,
            number,
            name,
            dndEndtime,
            dndEnabled,
            dndRemainingTime,
            dndOn,
            dndDuration,
            unseenMessageCount,
            order,
            sms,
            call,
            mms,
            status,
          }
        }
      }
    """;
  }

  String queryChannelInfo() {
    return """
    query channelInfo(\$channel: ShortId!)
    {
      channelInfo(channel: \$channel) 
      {
         data 
         {
            id
            country
            name
            countryLogo
            countryCode
            number
            call
            sms
            mms
            dndEndtime
            dndEnabled
            dndRemainingTime
            dndOn
            dndDuration
            unseenMessageCount
         }
         error 
         {
            message,
            errorKey,
            code,
         }
         status
      }
    }
    """;
  }

  String queryGetAllWorkSpaceMembers() {
    return """
      query allWorkspaceMembers(\$pageParams: ConnectionInput!)
      {
        allWorkspaceMembers(pageParams: \$pageParams) 
        {
          data 
          {
            edges
            {
              cursor
              node 
              {
                id
                firstname
                lastname
                role
                gender
                email
                online
                createdOn
                profilePicture
                unSeenMsgCount
                planRate
                {
                  planRate
                }
                numbers 
                {
                  name
                  number
                  country
                  countryLogo
                  countryCode
                }
                last_message
                {
                  message
                  type
                  createdOn
                  modifiedOn
                  status
                }
              }
            }
            pageInfo 
            {
              startCursor
              endCursor
              hasNextPage
              hasPreviousPage
            }
          }
          error 
          {
            message,
            errorKey,
            code,
          }
          status
        }
      }
    """;
  }

  String mutationCallAccessToken() {
    return """
      mutation memberLogin(\$data:MemberLoginInputData!) 
      {
        memberLogin(data:\$data)
        {
          status,
          data
          {
            accessToken,
            refreshToken
          }
          error
          {
            message,
            errorKey,
            code,
          } 
        }
      }
    """;
  }

  String mutationEditMemberChatSeen() {
    return """
      mutation editMemberChatSeen(\$senderId:ShortId!) 
      {
        editMemberChatSeen(senderId:\$senderId)
        {
          status,
          data
          {
            success,
          }
          error
          {
            message,
            errorKey,
            code,
          } 
        }
      }
    """;
  }

  String getUserProfileDetails() {
    return """
      query profile
      {
        profile
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            profilePicture,
            firstname,
            lastname,
            status,
            email,
            defaultLanguage,
            defaultWorkspace,
            stayOnline,
            dndEnabled,
            dndEndtime,
            dndDuration,
          }
        }
      }
    """;
  }

  String changeProfilePicture() {
    return """
      mutation changeProfilePicture(\$photoUpload: Upload!)
      {
        changeProfilePicture(photoUpload: \$photoUpload)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            profilePicture,
            firstname,
            lastname,
            status,
            email,
            defaultLanguage,
            defaultWorkspace,
            stayOnline,
            dndEnabled,
            dndEndtime,
            dndDuration,
          }
        }
      }
    """;
  }

  String mutationEditProfileName() {
    return """
      mutation changeProfileNames(\$data:ChangeProfileNames!) 
      {
        changeProfileNames(data: \$data)
        {
          status,
          data
          {
            firstname,
            lastname,
          },
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  // String changeProfileNames()
  // {
  //   return """
  //   mutation (\$data:ChangeProfileNames!)
  //   {
  //     changeProfileNames(data: \$data)
  //     {
  //       status,
  //       data
  //       {
  //           firstname,
  //           lastname,
  //           email,
  //           status,
  //           profilePicture,
  //           defaultLanguage,
  //           defaultWorkspace,
  //           stayOnline,
  //       },
  //       error
  //       {
  //         code,
  //         message
  //       }
  //     }
  //   }""";
  // }

  String mutationEditUserEmail() {
    return """
      mutation changeEmail(\$data: ChangeEmailInputData!)
      {
        changeEmail (data: \$data)
        {
          status
          data
          {
            success
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationUploadProfileImage() {
    return """
      mutation changeProfilePicture(\$photo_upload:Upload!) 
      {
        changeProfilePicture(photoUpload:\$photo_upload){
          status,
          data
          {
            firstname,
            lastname,
            defaultLanguage,
            defaultWorkspace,
            profilePicture,
            email,
          },
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationChangePassword() {
    return """
      mutation changePassword(\$data:ChangePasswordInputData!) 
      {
        changePassword(data: \$data)
        {
          status,
          data
          {
            success
          },
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String getAllContacts() {
    return """
      query newContacts(\$tags:[ShortId]) 
      {
        newContacts(tags: \$tags)
        {
          data 
          {
            id,
            email,
            name,
            number,
            address,
            company,
            visibility,
            clientId,
            country,
            blocked,
            profilePicture,
            markAsRead,
            dndEndtime,
            dndEnabled,
            dndDuration,
            createdBy,
            createdAt,
            tags
            {
              id,
              title,
              colorCode,
              backgroundColorCode,
            },
            dndInfo
            {
              dndDuration,
              dndEnabled,
              dndEndtime,
            },
          },
          error 
          {
            message,
            errorKey,
            code,
          }
          status,
        }
      }
    """;
  }

  // dndEnabled,
  // dndEndtime,
  // dndDuration,
  String queryContactDetail() {
    return """
      query contact(\$uid:ShortId!) 
      {
        contact(id:\$uid)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          },
          data
          {
            id,
            name,
            country,
            number,
            company,
            address,
            visibility,
            clientId,
            profilePicture,
            createdOn,
            blocked,
            email,
            dndInfo
            {
              dndDuration,
              dndEnabled,
              dndEndtime,
            },
            tags
            {
              id,
              title,
              colorCode,
              backgroundColorCode,
            },
          }
        }
      }
    """;
  }

  String queryContactDetailByNumber() {
    return """
      query clientDetail(\$number:String!) 
      {
        clientDetail(number:\$number)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          },
          data
          {
            id,
            name,
            country,
            number,
            company,
            address,
            visibility,
            clientId,
            dndEnabled,
            dndEndtime,
            dndDuration,
            profilePicture,
            blocked,
            email,
            tags
            {
              id,
              title,
              colorCode,
              backgroundColorCode,
            },
            dndInfo
            {
              dndDuration,
              dndEnabled,
              dndEndtime,
            },
          }
        }
      }
    """;
  }

/*query for getting all contries*/
  String getAllCountries() {
    return """
      query allCountries 
      {
        allCountries
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            uid
            dialingCode,
            alphaTwoCode,
            name,
            flagUrl
          }
        }
      }
    """;
  }

  String getAllAreaCodes() {
    return """
      query allAreaCodes
      {
        allAreaCodes
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            country,
            state,
            stateCenter,
            code,
            alphaTwoCode,
            dialingCode,
            dialCode,
            flagUrl,
          }
        }
      }
    """;
  }

/*mututation for uploading new contacts*/
  String mutationAddNewContacts() {
    return """
      mutation addContact(\$data: ContactInputData!) 
      {
        addContact(data: \$data)
        {
          status,
          data
          {
            id,
            country,
            number,
            email,
            address,
            visibility,
            name,
            notes
            {
              id,
              title
            }
            tags
            {
              id,
            }
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

/*mututation for adding new contacts*/
  String mutationUploadContacts() {
    return """
      mutation uploadBulkContacts(\$data: bulkContactsInput!) 
      {
        uploadBulkContacts(data: \$data) 
        {
          status
          error 
          {
            message,
            errorKey,
            code,
          }
          data
          {
            totalRecords
            savedRecords
          }
        }
      } 
    """;
  }

  /*mututation for delete contacts*/
  String mutationDeleteContacts() {
    return """
      mutation deleteContacts(\$data: DeleteContactsInputData!) 
      {
        deleteContacts(data: \$data)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            success
          }
        }
      }
    """;
  }

  /*Query for App Info*/
  String queryAppInfo() {
    return """
      query appRegisterInfo(\$app_type: String!)
      {
        appRegisterInfo(app_type: \$app_type)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            versionNo,
            versionForceUpdate,
            versionNeedClearData,
            versionNo,
            appType,
            featureList,
            modifiedOn,
            isReleased,
            appURL
          }
        }
      }
    """;
  }

  //Call Logs

  String queryCallLogs() {
    return """
      query recentConversation(\$channel: ShortId!, \$params: ConnectionInput!)  
      {
        recentConversation(channel: \$channel, params: \$params)
        {
          status,
          data
          {
            pageInfo 
            {
              startCursor,
              endCursor,
              hasNextPage,
              hasPreviousPage,
            },
            edges 
            {
              cursor,
              node
              {              
                id,
                conversationStatus,
                conversationType,
                direction,
                createdAt,
                clientNumber,
                contactPinned,
                clientCountry,
                clientUnseenMsgCount,
                status,
                content
                {
                  body,
                  duration,
                  transferedAudio,
                  transcript,
                },
                personalizedInfo 
                {
                  pinned,
                  seen,
                  favourite,
                  reject,
                },
                clientInfo
                {
                  id,
                  name,
                  number,
                  country,
                  createdBy,
                  profilePicture,
                  blocked,
                  dndEnabled,
                  dndDuration,
                  dndEndtime,
                  dndInfo {
                    dndEnabled,
                    dndDuration,
                    dndEndtime
                  }
                },
                agentInfo{
                  agentId,
                  firstname,
                  lastname,
                  profilePicture
                }
              },
            },
          },
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationPinConversationContact() {
    return """
      mutation addPinned(\$data: PinnedInputData!)
      {
        addPinned(data: \$data)
        {
          status,
          data
          {
            success
          },
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  ///todo
  /// voicemailAudio, add in content to know voicmail or recording if voicmail null check 1st and body 2nd
  String queryConversationByContactNumber() {
    return """
      query conversation(\$channel: ShortId!, \$contact: String!, \$params: ConnectionInput) 
      {
        conversation(channel: \$channel, contact: \$contact, params: \$params) 
        {
          status,
          data 
          {
            pageInfo 
            {
              startCursor,
              endCursor,
              hasNextPage,
              hasPreviousPage,
            },
            edges 
            {
              cursor,
              node 
              {
                id,
                conversationStatus,
                conversationType,
                direction,
                createdAt,
                clientNumber,
                contactPinned,
                clientCountry,
                clientUnseenMsgCount,
                status,
                content
                {
                  body,
                  duration,
                  transferedAudio,
                  transcript,
                },
                personalizedInfo 
                {
                  pinned,
                  seen,
                  favourite,
                  reject,
                },
                clientInfo
                {
                  id,
                  name,
                  number,
                  country,
                  createdBy,
                  profilePicture,
                  blocked,
                },     
                agentInfo
                {
                  agentId,
                  firstname,
                  lastname,
                  profilePicture
                }
              },
            },
          },
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String queryConversationByMember() {
    return """
      query chatHistory(\$member: ShortId!,\$params: ConnectionInput) 
      {
        chatHistory(params: \$params, member: \$member) 
        {
          status
          data 
          {
            pageInfo 
            {
              startCursor,
              endCursor,
              hasNextPage,
              hasPreviousPage,
            },
            edges 
            {
              cursor
              node 
              {
                id
                message
                createdOn
                modifiedOn
                sender
                {
                  id,
                  firstname,
                  lastname,
                  picture,
                }
                receiver
                {
                  id,
                  firstname,
                  lastname,
                  picture
                }
                status
                type
              }
            }
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String queryRecordingByContactNumber() {
    return """
      query clientRecordings(\$channel: ShortId!, \$contact: String!, \$params: ConnectionInput) 
      {
        clientRecordings(channel: \$channel, contact: \$contact, params: \$params) 
        {
          status
          data 
          {
            pageInfo 
            {
              startCursor
              endCursor
              hasNextPage
              hasPreviousPage
            }
            edges 
            {
              cursor
              node 
              {
                id
                createdAt
                seen
                content 
                {
                  duration,
                  body,
                  callDuration,
                  callTime,
                  transferedAudio,
                  transcript,
                }
              }
            }
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationSendNewMessage() {
    return """
      mutation sendMessage(\$data: ConversationInput!) 
      {
        sendMessage (data: \$data)
        {
          status,
          data 
          {
            id,
            conversationStatus,
            conversationType,
            direction,
            createdAt,
            clientNumber,
            contactPinned,
            clientCountry,
            clientUnseenMsgCount,
            status,
            content
            {
              body,
              duration,
              transferedAudio,
              transcript,
            },
            personalizedInfo 
            {
              pinned,
              seen,
              favourite,
              reject,
            },
            clientInfo
            {
              id,
              name,
              number,
              country,
              createdBy,
              profilePicture,
              blocked,
            },
          },
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationSendChatMessage() {
    return """
      mutation createChatMessage(\$data: ChatMessageInput!) 
      {
        createChatMessage(data: \$data)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id
            sender
            {
              id,
              firstname,
              lastname
              picture,
            }
            receiver
            {
              id,
              firstname
            }
            message
            type
            status
          }
        }
      }
    """;
  }

  String subscriptionUpdateConversationDetail() {
    return """
      subscription updateConversation(\$channel: ShortId!) 
      {
        updateConversation(channel: \$channel) 
        {
          event,
          message
          {
            id,
            conversationStatus,
            conversationType,
            direction,
            createdAt,
            clientNumber,
            contactPinned,
            clientCountry,
            clientUnseenMsgCount,
            status,
            content
            {
              body,
              duration,
              transferedAudio,
              transcript,
            },
            personalizedInfo 
            {
              pinned,
              seen,
              favourite,
              reject,
            },
            clientInfo
            {
              id,
              name,
              number,
              country,
              createdBy,
              profilePicture,
              blocked,
              dndInfo
              {
                dndEnabled,
                dndDuration,
                dndEndtime
              }
            },
            channelInfo
            {
              channelId,
              number,
              country,
            }
            agentInfo
            {
              agentId,
              firstname,
              lastname,
              profilePicture,
            }
          }
        }
      }
    """;
  }

  String subscriptionWorkspaceChatDetail() {
    return """
      subscription workspaceChat
      {
        workspaceChat
        {
          event,
          message 
          {
            id
            sender
            {
              id,
              firstname,
              lastname
              picture,
            }
            receiver
            {
              id,
              firstname,
              lastname,
              picture,
            }
            message
            type
            createdOn
            modifiedOn
            status
          }
        } 
      }
    """;
  }

  String subscriptionOnlineMemberStatus() {
    return """
      subscription onlineMemberStatus(\$workspace: ShortId!) 
      {
        onlineMemberStatus(workspace: \$workspace) 
        {
          event,
          message 
          {
            id,
            online,
          }
        }
      }
    """;
  }

  String getNewCount() {
    return """
      query newCount(\$channel: ShortId!) 
      {
        newCount(channel: \$channel) 
        {
          status,
          data,
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String callRecord() {
    return """
      mutation callRecording(\$data: RecordCallInput!) 
      {
        callRecording(data: \$data)
        {
          status,
          data
          {
            status
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationAddTagsToContact() {
    return """
      mutation editContact(\$id: ShortId! ,\$data: EditContactInputData!) 
      {
        editContact(data: \$data, id: \$id)
        {
          status,
          data
          {
            tags
            {
              id,
              title,
              colorCode,
              backgroundColorCode,
              count,
            },
            notes
            {
              id,
              title,
            },
          },
          error
          {
            message,
            errorKey,
            code,
          },
        }
      }
    """;
  }

  /*client dnd*/
  String mutationUpdateClientDnd() {
    return """
      mutation updateClientDND(\$data: ClientDNDInput!)
      {
        updateClientDND(data: \$data)
        {
          status,
          data
          {
            id,
            email,
            name,
            createdOn,
            number,
            address,
            company,
            visibility,
            blocked,
            dndEnabled,
            dndDuration,
            createdBy,
            clientId,
            country,
            profilePicture
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationBlockContact() {
    return """
      mutation blockContact(\$uid:ShortId!, \$data:BlockContactInputData!) 
      {
        blockContact(id:\$uid, data:\$data)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id,
            blocked,
          }
        }
      }
    """;
  }

  String mutationBlockNumber() {
    return """
      mutation blockNumber(\$number:String!, \$data:BlockNumberInputData!) 
      {
        blockNumber(number:\$number, data:\$data)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id,
            blocked,
          }
        }
      }
    """;
  }

  String queryConversationSearch() {
    return """
      query conversation(\$channel: ShortId, \$contact: ShortId, \$params: ConnectionInput) 
      {
        conversation(channel: \$channel, contact: \$contact, params: \$params) 
        {
          status
          data 
          {
            pageInfo 
            {
              startCursor
              endCursor
              hasNextPage
              hasPreviousPage
            }
            edges 
            {
              cursor
              node 
              {
                id
                agentProfilePicture
                clientNumber
                channelNumber
                clientCountry
                clientName
                clientProfilePicture
                channelCountry
                createdAt
                content 
                {
                  body
                  duration
                }
                conversationType
                conversationStatus
                direction
              }
            }
          }     
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationAddNoteToContact() {
    return """
      mutation addNote(\$clientId:ShortId!, \$data: NoteInputData!) 
      {
        addNote(clientId:\$clientId, data: \$data)
        {
          status,
          error,
          {
            message,
            errorKey,
            code,
          }
          data
          {
            title,
          },
        }   
      }
    """;
  }

  String mutationAddNoteByNumber() {
    return """
      mutation addNoteByContact(\$contact:String!, \$data: NoteInputData!)
      {
        addNoteByContact(contact:\$contact, data: \$data)
        {
          status,
          error,
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id,
            title,
            client
            {
              id,
              name,
              country,
              number,
              company,
              address,
              visibility,
              clientId,
              profilePicture,
              blocked,
              email,
              tags
              {
                id,
                title,
                colorCode,
                backgroundColorCode,
              },
            }
          },
        }   
      }
    """;
  }

  String transferCall() {
    return """
      query coldTransfer(\$data: TransferInput!) 
      {
        coldTransfer(data: \$data) 
        {
          status
          data
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String warmTransferCall() {
    return """
      mutation warmTransfer(\$data: WarmTransferInput!) 
      {
        warmTransfer(data: \$data) 
        {
          status
          data 
          {
            conversationStatus
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String callHold() {
    return """
      mutation callHold(\$data: HoldCallInput!) 
      {
        callHold(data: \$data)
        {
          status
          data
          {
            message
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String queryTeams() {
    return """
      query teams
      {
        teams
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id,
            title,
            name,
            total,
            description,
            avatar,
            teamMembers
            {
              id,
              firstname,
              lastname,
              online,
            }
          }
        }
      }
    """;
  }

  /*Todo need to add the countrylogo and countrycode after
  *  the numbers query is updated in backend  */
  // countryLogo
  // countryCode

  String queryMyNumbers() {
    return """
      query numbers 
      {
        numbers
        {
          status
          data 
          {
            id
            name
            number
            agents 
            {
              id
              firstname
              lastname
              photo
            }
            callStrategy
            numberCheckoutPrice 
            {
              setUpFee
              monthlyFee
            }
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String planOverView() {
    return """
      query planOverview
      {
        planOverview
        {
          status
          data
          {
            customerId
            currentPeriodEnd
            hideKrispcallBranding
            dueAmount
            subscriptionActive
            card
            {
              id
              name
              expiryMonth
              expiryYear
              brand
              lastDigit
            }
            credit
            {
              id
              amount
            }
            plan
            {
              id
              title
              rate
            }
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String getWorkspaceCredit() {
    return """
      query getWorkspaceCredit 
      {
        getWorkspaceCredit
        {
          status
          data 
          {
            currentCredit
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String queryClientNotes() {
    return """
      query clientNotes(\$contact: String!, \$channel: ShortId!) 
      {
        clientNotes(contact:\$contact, channel: \$channel)
        {
          status,
          error
          {
            message,
            errorKey,
            code,
          }
          data
          {
            id,
            title,
            createdAt,
            modifiedAt,
            userId,
            firstName,
            lastName,
            profilePicture,
          }
        }
      }
    """;
  }

  String queryWorkSpaces() {
    return """
      query workspaces
      {
        workspaces
        {
          status
          data
          {
            id,
            title,
            photo,
            memberId,
            tags
            {
              id,
              title,
              colorCode,
              backgroundColorCode,
            }
            status
            order
            plan
            {
              cardInfo
              remainingDays,
              subscriptionActive,
              trialPeriod
            }
            review
            {
              review_status
              risk_score
            }
          }
          status
        }
      }
    """;
  }

  String mutationRefreshToken() {
    return """
      mutation refreshToken
      {
        refreshToken
        {
          status,
          data
          {
            accessToken
          }
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String changeWorkSpacePhoto() {
    return """
      mutation changeWorkspacePhoto(\$photoUpload: Upload!)
      {
        changeWorkspacePhoto(photoUpload: \$photoUpload)
        {
          status
          error 
          {
            message,
            errorKey,
            code,
          }
          data 
          {
            id
            title
            photo
          }
        }
      }
    """;
  }

  String subscriptionUserProfile() {
    return """
      subscription userProfile(\$user : ShortId!)
      {
        userProfile(user:\$user)
        {
          event
          message
          {
            profilePicture,
            firstname,
            lastname,
            status,
            email,
            defaultLanguage,
            defaultWorkspace,
            stayOnline,
            dndEnabled,
            dndEndtime,
            dndDuration,
          }
        }
      }
    """;
  }

  String queryPinnedCallLogs() {
    return """
      query contactPinnedConversation(\$channel: ShortId!, \$params: ConnectionInput!)  
      {
        contactPinnedConversation(channel: \$channel, params: \$params)
        {
          status,
          data 
          {
            id,
            conversationStatus,
            conversationType,
            direction,
            createdAt,
            clientNumber,
            contactPinned,
            clientCountry,
            clientUnseenMsgCount,
            status,
            content
            {
              body,
              duration,
              transferedAudio,
              transcript,
            },
            personalizedInfo 
            {
              pinned,
              seen,
              favourite,
              reject,
            },
            clientInfo
            {
              id,
              name,
              number,
              country,
              createdBy,
              profilePicture,
              blocked,
              dndInfo
              {
                dndEnabled,
                dndDuration,
                dndEndtime
              }
            },
            agentInfo
            {
              agentId,
              firstname,
              lastname,
              profilePicture
            }
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationForgotPassword() {
    return """
      mutation forgotPassword(\$data:ForgotPasswordInput!)
      {
        forgotPassword(data:\$data)
        {
          status,
          data
          {
            message,
            code,
          }
          error
          {
            message,
            errorKey,
            code,
          },
        },
      }
    """;
  }

  String queryGetLastContactedDate() {
    return """
      query lastContactedTime(\$contact: String!) 
      {
        lastContactedTime(contact: \$contact) 
        {
          status
          error 
          {
            message,
            errorKey,
            code,    
          }
          data 
          {
            createdAt
          }
        }
      }
    """;
  }

  String queryGetUserNotificationSetting() {
    return """
      query notificationSettings
      {
        notificationSettings
        {
          data 
          {
            id,
            version,
            platform,
            fcmToken,
            callMessages,
            newLeads,
            flashTaskbar,
          }
          error 
          {
            message,
            errorKey,
            code,
          }
          status
        }
      }
    """;
  }

  String mutationUpdateUserNotificationSetting() {
    return """
      mutation updateNotificationSettings(\$data: UpdateNotificationsInputData!)
      {
        updateNotificationSettings(data: \$data)
        {
          data 
          {
            id,
            version,
            platform,
            fcmToken,
            callMessages,
            newLeads,
            flashTaskbar,
          }
          error 
          {
            message,
            errorKey,
            code,
          }  
          status
        }
      }
    """;
  }

  String queryGetUserPermissions() {
    return """
      query permissions
      {
        permissions
        {
          data,
          status,
          error
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String mutationNumberSetting() {
    return """
      query numberSettings(\$channel: ShortId!)
      {
        numberSettings(channel: \$channel)
        {
          data 
          {
            id,
            name,
            emoji,
            autoRecordCalls,
            externalNumber,
            externalFallbackNumber,
            internationalCallAndMessages,
            emailNotification,
            transcription,
            incomingCallStrategy,
            incomingCallForward,
            unanswerCallsFallback,
            shared,
            abilities
            {
              call
              sms
              mms
            }
          }
          error 
          {
            message,
            errorKey,
            code,
          },
          status
        }
      }
    """;
  }

  String queryPlanRestriction() {
    return """
      query planRestrictionData()
      {
        planRestrictionData()
        {
          data,
          error 
          {
            message,
            errorKey,
            code,
          },
          status,
        }
      }
    """;
  }

  String mutuationUserDnd() {
    return """
      mutation setUserDND(\$data: UserDNDInput!) 
      {
        setUserDND(data: \$data) 
        {
          status
          data 
          {
            dndEnabled
            dndEndtime
            dndRemainingTime
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String updateGeneralSettings() {
    return """
      mutation updateGeneralSettings(\$channel: ShortId!, \$data: GeneralChannelSettingsInput!)
      {
        updateGeneralSettings(channel: \$channel, data: \$data) 
        {
          status
          data 
          {
            name
            autoRecordCalls
            internationalCallAndMessages
            emailNotification
            transcription
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String setChannelDnd() {
    return """
      mutation setChannelDnd(\$id: ShortId!, \$minutes: Int) 
      {
        setChannelDnd(id: \$id, minutes: \$minutes) 
        {
          status   
          data 
          { 
            dndEnabled
            dndEndtime
            dndRemainingTime
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String removeChannelDnd() {
    return """
      mutation removeChannelDnd(\$id: ShortId!) 
      { 
        removeChannelDnd(id: \$id) 
        { 
          status   
          data 
          {
            success
          }    
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String queryGetAllTeamsMember() {
    return """
      query teamMembersList(\$id: ShortId!, \$params: ConnectionInput!)
      {
        teamMembersList(id: \$id, params: \$params) 
        {
          data 
          {
            edges
            {
              cursor
              node 
              {
                id
                email
                firstname
                lastname
                photo
                role
                createdOn
                online
              }
            }
            pageInfo 
            {
              startCursor
              endCursor
              hasNextPage
              hasPreviousPage
            }
          }
          error 
          {
            message,
            errorKey,
            code,
          }
          status
        }
      }
    """;
  }

  String mutationUpdateTeamsMember() {
    return """
      mutation updateTeam(\$id: ShortId!, \$data: UpdateTeamInputData!)
      {
        updateTeam(id: \$id, data: \$data) 
        {
          data 
          {
            id
          }
          error 
          {
            message,
            errorKey,
            code,
          }
          status
        }
      }
    """;
  }

  String callRating() {
    return """
      mutation callRating(\$id: ShortId!, \$data: CallRatingInputData!)
      {
        callRating(id: \$id, data: \$data) 
        {
          data 
          {
            success
          }
          error 
          {
            message,
            errorKey,
            code,
          }
          status
        }
      }
    """;
  }

  String mutationEditWorkspace() {
    return """
      mutation editWorkspace(\$data: EditWorkspaceInputData!)
      {
        editWorkspace(data: \$data)
        {
          data 
          {
            id,
            title,
          }
          error 
          {
            message,
            errorKey,
            code,
          }
          status
        }
      }
    """;
  }

  String mutationConversationSeen() {
    return """
      mutation conversationSeen(\$contact: String!, \$channel: ShortId!)
      {
        conversationSeen(contact: \$contact, channel: \$channel)
        {
          data 
          {
            success,
          }
          error 
          {
            message,
            errorKey,
            code,
          }
          status
        }
      }
    """;
  }

  String blockContacts() {
    return """
      query blockedContacts()
      {
        blockedContacts() 
        {
          status
          error 
          {
            message,
            errorKey,
            code,
          }
          data 
          {
            id,
            email,
            name,
            country,
            number,
            company,
            createdBy
            address,
            visibility,
            clientId,
            dndEnabled,
            dndEndtime,
            dndDuration,
            profilePicture,
            blocked,
            tags
            {
              id,
              title,
              colorCode,
              backgroundColorCode,
            },
          }
        }
      }
    """;
  }

  String getMacros() {
    return """
      query macros()
      {
        macros() 
        {
          status
          error 
          {
            message,
            errorKey,
            code,
          }
          data 
          {
            id
            message
            title
            type
          }
        }
      }
    """;
  }

  String addMacros() {
    return """
      mutation addMacros(\$data: MacrosInputData!)
      {
        addMacros(data: \$data) 
        {
          status
          data 
          {
            id
            title
            message
            type
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }

  String removeMacros() {
    return """
      mutation removeMacros(\$id: ShortId!) 
      {
        removeMacros(id: \$id) 
        {
          status    
          data 
          {
            id
            title
            message
            type
          }
          error 
          {
            message,
            errorKey,
            code,
          }
        }
      }
    """;
  }
}

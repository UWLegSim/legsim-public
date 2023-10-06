json.mailbox_body @letters.collect { |letter|
"<tr>
    <td style='width:0px'><input type='checkbox' /></td>
    <td style='width: 40%'>#{ link_to_user( letter.chamber_role ) }</td>
    <td class='email-subject' style='width: 40%'>#{ link_to letter.subject, letter_path( letter ) }</td>
    <td style='text-align: center;'>#{ letter.created_at.strftime("%m/%d/%Y<br/>%I:%M&nbsp;%p") }</td>
  </tr>"
}.join
json.mailbox_footer "<a href='#newest' title='Newest'>&#171; Newest</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href='#newer' title='Newer'>&#171; Newer</a>&nbsp;&nbsp;|&nbsp;&nbsp;<strong>#{@offset+1}-#{@letter_count < @offset+@limit ? @letter_count : @offset+@limit}</strong> of <strong>#{@letter_count}</strong>&nbsp;&nbsp;|&nbsp;&nbsp;<a href='#older' title='Older'>Older &#187;</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href='#oldest' title='Oldest'>Oldest &#187;</a>"
json.offset @offset
json.total  @letter_count
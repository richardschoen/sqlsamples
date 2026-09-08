# Audit netbios file shares
Here is a security exposure that is almost invisible because it lives outside the authority model most people audit: your file shares. IBM i NetServer lets you share directories and libraries across the network as if the machine were a file server, and in many shops, shares were created over the years and never reviewed. Sometimes, or I should say, many times, this leaves huge security holes, and I have seen ransomware crawl into a system.

The risk is straightforward and serious. A share exposes part of your system to the network, and what people can do through that share depends on the share settings and the underlying authority. A read-write share pointed at the wrong directory, available to more people than anyone intended, is a data exposure sitting quietly in the open. And because shares are configured away from the classic green-screen authority screens, they rarely show up in a normal security review. Never share the root, and so many people do.

Here is how to see every share on your system:

```
SELECT SERVER_SHARE_NAME, SHARE_TYPE,
      PATH_NAME, PERMISSION,
      TEXT_DESCRIPTION
 FROM QSYS2.SERVER_SHARE_INFO
 ORDER BY SERVER_SHARE_NAME;
```

That lists every NetServer share, whether it is a file or print share, exactly what path it exposes, and whether it is read-only or read-write.

Read that list carefully. For each share, ask three questions. 
1) Does this still need to exist? 
2) Does it point exactly where it should and nowhere broader? 
3) Is read-write actually required, or would read-only do the job?

Every share that fails one of those questions is a small door standing open that you can quietly close, because otherwise you have a security hole.

This is one of those reviews that takes ten minutes and genuinely reduces your attack surface. Shares accumulate silently; they are easy to forget, and they are exactly the kind of thing an attacker or an auditor will find if you do not find it first.

Look at your shares this week. You may be surprised by what is still open. Check the root file share and use Navigator to find out who is using it before you remove it.

From LinkedIn post by Pete Massielo.

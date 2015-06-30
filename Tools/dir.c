
// dir.
// A simple, minimalistic puzzle game.


// This is a small stub exe to run dir on Windows.

// I prefer to distribute the vanilla Love2D without changes.
// This launcher changes the icon at runtime and keeps
// Love2D binaries and dir in separate directories (easier to manage).


#include <windows.h>


// Run a process with a given command-line and return the pid:

DWORD
RunProcess (char *cmd)
{
    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    CreateProcess(NULL,  // No module name (use command line).
         cmd,            // Command line.
         NULL,           // Process handle not inheritable.
         NULL,           // Thread handle not inheritable.
         FALSE,          // Set handle inheritance to FALSE.
         0,              // No creation flags.
         NULL,           // Use parent's environment block.
         NULL,           // Use parent's starting directory.
         &si,            // Pointer to STARTUPINFO structure.
         &pi);           // Pointer to PROCESS_INFORMATION structure.

    return pi.dwProcessId;
}


// Find the handle of a target window by its process id:

DWORD gTargetProcessId = 0;
HWND gTargetHwnd = NULL;

BOOL CALLBACK myWNDENUMPROC (HWND hwnd, LPARAM lp)
{
    if (hwnd == NULL)
        return TRUE;

    if (!IsWindowVisible(hwnd))
        return TRUE;

    DWORD dwProcessId;
    GetWindowThreadProcessId(hwnd, &dwProcessId);

    if (dwProcessId == gTargetProcessId)
    {
        gTargetHwnd = hwnd;
        return FALSE;
    }

    return TRUE;
}


// Entry-point:

int WINAPI
WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow)
{
    // get the icon for this exe (see also dir.rc):
    HICON icon = (HICON) LoadImage(hInstance, "ID_ICON", IMAGE_ICON, 128, 128, LR_DEFAULTCOLOR | LR_SHARED);

    // launch dir using Love2D:
    gTargetProcessId = RunProcess("love2d/love.exe dir/dir.love");

    // it can take a while to launch the process, so wait in a loop
    // until we can get the hwnd:
    while (gTargetHwnd == NULL) {
        EnumWindows(myWNDENUMPROC, (LPARAM) NULL);
        Sleep(0.1);
    }

    // change the hwnd icon:
    SendMessage(gTargetHwnd, WM_SETICON, ICON_BIG, (LPARAM) icon);

    return 0;
}

